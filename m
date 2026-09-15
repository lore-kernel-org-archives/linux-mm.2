Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CADBC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 23:49:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2991B6B0088; Tue, 15 Sep 2026 19:49:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2499F6B008C; Tue, 15 Sep 2026 19:49:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1614F6B0092; Tue, 15 Sep 2026 19:49:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E06B66B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:49:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 328921A0561
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:49:49 +0000 (UTC)
X-FDA: 85217641698.22.4ED2D98
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 85DBBA0002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:49:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="R37/l7MY";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789516187;
	b=62zVSOrETuy8Dc9gtxws9zelD1W54RsJ4fL7pbkW9K7SSzVYIqPCAZwVbIkiPuilfJkU0N
	ijy3sq1Uip08THDlAx2Q6JblF2u/OjnWTlJ+81zxacI24YwJYOapoKaWF6x6n28eh/MWAO
	/tlSw1qY93Yq2E6ZylOijLJX3YFVO1g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="R37/l7MY";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789516187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wfsqsA42RTLaHAcEouHB0BdpY6IKOeqMBzzSUc5mNWU=;
	b=FjkcgMvJBVVcm4ui69l50xIinZRF33C26sgPuSY0MPNmmWghfUAXoAWcvIEVSaNTBvQ7DU
	16uUZ4suov9bXhZGO58Begf+5bEiflYZJaLws39FZFs4jSZ59iW1c3MpmqBBS54eGZybYc
	lqFywRZJNzmCS3/jmbtmubym25mtPbE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AA4FB60008;
	Tue, 15 Sep 2026 23:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE551F000FF;
	Tue, 15 Sep 2026 23:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789516186;
	bh=wfsqsA42RTLaHAcEouHB0BdpY6IKOeqMBzzSUc5mNWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R37/l7MYIzsZWvs5bZA4sl2BNGKXaeQTUKIkLpnn4ERbwxLWzRGTp42Lb49HJVLOZ
	 fL/IWFbPUll5P8RPuLLKKdJsieaNIvHIcM88ihHRTbiehVsx+0TIuFSwwXH2nZ1Z/h
	 WYqTy49GZ1Wc9VebvC3D3CLEsoI8gHOm/er7yzjX7qdQiWoZ4633W0vSIKotxr3Eeu
	 V+s8vWfD3KA6XnS0C+e+qSli92CS7cUQwWv4JRf6FXvEbxSrtFbpCScZp2999cHcbG
	 qntq+e82CwPXl30d/H4odHWaEruwXvx/Hn2OPgkkxb6Rx68+RT2IhpQG89kGgGC2cF
	 NAu0dogVEyUvg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/8] mm/damon: introduce hugepage_size probe filter
Date: Tue, 15 Sep 2026 16:49:38 -0700
Message-ID: <20260915234938.98475-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915163928.9d6260f445d895429d115fd8@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 85DBBA0002
X-Stat-Signature: 1by8bxufi49bc1smpk7x33m1ayfxrmxt
X-HE-Tag: 1789516187-685855
X-HE-Meta: U2FsdGVkX1+NrHmh2rPBIG6ALu6fSQ2TTGbhZW7JwksRC6APIP/oEz1B1OL+CvCsUTnpeI9jmEX7N8ZvzefecV0AbWPxtgsYZHt+Gv0p2FRaSy0VJ0z260ARcsB/kDAFgULdFlrHuOFpjcrhFr0OgLl8eybW/XMMz51xx4XKPPyXSGWuKdH2BteYk7L8qyFcOcEocoR+PA8+tiuDVnj5t/zoVpEekepvg+1XC5OeZqPka1rSCgiaLcRKvDgiSFxVccscoc4zHb+z/qAZptXUS/mSd1rVDfKhaOLL2P2tij2UzwyX1/oPNlOvbM9ig7mFRmbG8mvvTKI1Wh0M5dDA8UTU4uF2YFSrWkJXnrM0FOXPJmDSLCst58JBCGX4tabbVuymXTkpFmAic+6rNJioGwzZ4Jb8o98UbssGQ2SxaTfy13djIKVeJ05q6K3885YWqlq8TiQbBuMFnYTIdMIK5/HyXDRmq9GMudymSzXpymlRa0B6llzbRdBEUh0sZ8TZD0wWVfNZM6y8Kl5dNLtcKgGVLpvZvEVrPRKDYnJduh2+xQUIJ7WNhziWdE3bq/CMiwl41V2ucJtuEMsAwYUXSjeQfOCrsDn99B/f1owlcjts9QrOsuf/V7UxoFP4QIYaRKFMopR5jDONt6PmUiIbSiWzKKOrwkaEDRFot1z3fG0lgTDECPuNUKAkrJH++6Tb+WNXstTQ19WqbetQ2eO1mLwjX5Nzav5YT8e3sFa60n0BtDbYhjFbt29t5RDu95sb1hDDZKu0OCn+kZosEpReDNhCqlTNA2IgxQ4cQcPCfjO7e4FRKiU24ij4f8Gw10CRF4F562sHx86nP7OkM6E/1XKCfusjhfsqcoWl+QN0zaepWiU8XwLnDwv6o+1fXNYfiKy6ZnxUSQW0yHrkTVSJ3RtBYBGXRAh2h7xx21qM44ZS+maVrSjnaJR9B1xAN0qG56/EoOtx6BFix+ALsBn
 s/EL+1ez
 A78nCnvBPeEAMuJe966OmfHjJbwgIS46pa3ABdrYWbmg2XSvPB+OFIesSHmK3jLomtxdmcvEGaVgPrN1J2y7TfLGBhUrXQemZX4dDl5+zpjo525C6FVoV/WkvXQhLN780dVRPNcopBdYFtIqVUrSnK0oKrZYaiw0oqm0M0weO5Y+RZ7kyOmmZ9MbcVjsACsDtvAzFZvDHcTtgGS0twTDl+JcfVbuLyXNS2q82s8wlQxn9WudKmG0VF7dmq7mJ/P4AYugrSZTaj3XVzw1ZtNM4HxFIgyQ1NuBj7IZxNBoM+UH1NLI/NBNTkEal5t8XGOZ9ZcZiPyI5qi6vK7FNT+zu19gtpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 16:39:28 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 15 Sep 2026 07:33:49 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > Knowing whether a given memory is backed by a hugepage of specific size
> > is useful for efficient utilization of hugepages.  For easy monitoring
> > of the information, introduce a new data attribute probe filter type,
> > hugepage_size.  It works similar to the DAMOS filter of the same name.
> > It works for memory that is backed by a hugepage of a given size range.
> > 
> > Patch 1 introduces the new probe filter type to DAMON API and extends
> > related data structures.  Patch 2 updates probe filter commit logic to
> > handle the size range.  Patch 3 Updates the filtering logic to support
> > the new type.  Patch 4 adds new DAMON sysfs files for the size range.
> > Patch 5 updates DAMON sysfs interface to fully support the new filter
> > type.  Patches 6-8 updates design, usage and ABI documents for the new
> > feature.
> 
> All queued up, thanks.  With a -fix for [7/8].
> 
> > Test
> 
> fyi, I'm always reluctant to include testing info in the permanent
> record.  Because it's development-time info which becomes obsolete very
> quickly.
> 
> It isn't useful to someone who is reading the changelog in mainline in
> 2028 (or even Nov 2026) because the patchset will have had far more testing
> since these words were written.
> 
> It is of course very useful info but I suggest it be maintained below
> the "---", where all short-term development-time info is best
> maintained.

Agreed.  I will do so for individual patches.  For cover letters that don't
have the "---" lines, I will add an informal note saying "please do not add
below to the commit message".  If you prefer, I could add "---" line on the
cover letter instead of the informal note.  Or, I could add the informal note
below the manual "---" line, too.  Let me know if you prefer that.


Thanks,
SJ

