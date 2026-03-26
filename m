Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AE2B106F2E3
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 07:51:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9AB6B0005; Thu, 26 Mar 2026 03:51:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96AA16B0088; Thu, 26 Mar 2026 03:51:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880546B0089; Thu, 26 Mar 2026 03:51:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9046B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:51:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 299661B92C6
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:51:49 +0000 (UTC)
X-FDA: 84587445138.22.F2CD824
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 75702180006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:51:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uo442Gsc;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774511507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l8feyCpEBntX+r44cIJ3u/soHSdeYNZPByLjw7lkLyo=;
	b=3Uv3cpcdQzWsNX2t8FizaJlicQs7vpKjTxQrWSuiJZBSTQ+wHsUfk1TE9vgauG3qbITM5Z
	qAJfIjHYdz3HulZ2kEto7LFq5EUrIFEibNCjPtiHmI/6rWzsDJOLch+UPPODW4jnoYmhdq
	pzUGONLgd2VnHZ+tSbK0iBQcn7BvwgA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uo442Gsc;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774511507; a=rsa-sha256;
	cv=none;
	b=nMIskmvIyon5GTnzB7GPbbLP77jNhlLwLwQq5jIMS94HFX/vfL+6SlOHRdbmUgExIbU+Rw
	0lW3q+wp4nvfSIjFV/ZM5Yx8F451OnHxOxCVlwoN9aT20lEDmZU3EB2ifDRlq/LziAbHeu
	55HKB7m0ans0Di/7HlyZ+BXcOmiuO80=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B86143F89;
	Thu, 26 Mar 2026 07:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1377C2BCB6;
	Thu, 26 Mar 2026 07:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774511506;
	bh=oq3tl6l65dbdiBDBB/a3W2orhb+HovVIBT226iNNBu8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Uo442GsciOK6onkG1AEsLvJdq82PjiY/TBiBo++AW/LvKuUBvogNKTQIAkLXRTJEp
	 /uh310z1gCJDOwPp4LEuI/kBJbsEe1xBWfLWRy8MWvQJcswA1W8g20B8iAcB99NpB5
	 MjVcUluBaJR+DtHDC1+f2goXJCvmu/qm8Ah6ZfsbIUQ8fS7S/j0I2SPbRpzZ7icrMD
	 1cs6lighWRCPLvN9QXZ0tT1g7+M1x9LmXHM/BSbpyMj+bt0wAfI3ORJE2mWu9+9l3V
	 DnqsxRmWDy5ArNPDyCZmU5OE7A1PIAdqnTVzM3kJWTxPhsaVULXxyEGRGAAi8RMkpE
	 U2UFx57k5KbXA==
Date: Thu, 26 Mar 2026 16:51:44 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org,
	ziy@nvidia.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com,
	mkoutny@suse.com, akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 0/4] fix unexpected type conversions and potential
 overflows
Message-ID: <acTlkB9WOGzVJCEo@hyeyoo>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
 <acTc3JugF71I9Eep@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acTc3JugF71I9Eep@tiehlicka>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 75702180006
X-Stat-Signature: ft7cih6911ij9tw89kcgwhr19dmokm7c
X-Rspam-User: 
X-HE-Tag: 1774511507-360871
X-HE-Meta: U2FsdGVkX18vVAJRgNlVrNMaMrmQEXUL6o+xMd/cuvaGdDhiQFSVPKV8bJTbJgvt+LIXj4p4M6BeajXJYDAKQ6rjo8dE7oUhQMuJw9gp4UeeOsbsh9N//JrXWzqI5+YRejykYfNU+Mf2BSl5Mm5it/p6F/79EHoD9/hRROSHIGI1V8z5c04tTIJs+JUghbeeGZCLGgiP0w/+/Ho7S5ljDgw9dsUTrnOAAeIramuIBQUCpa1Uc/n/49iORKS6ET5Kzav70839wWV7ErLEcTKigdB3aVnDFr+Z+I2PfJKK8PPFq0fTL5LLvHzjmYWZs7+ISEZ28/LSXs6ZmtOvpzXGUkSADnF/nrDKLdbAhR8t4moWBHBFTbJzHfUJMQVHW01596cVtgLsZ88KX9f8kTk4z1An2eI+vC7GsOqbH8v0Z4aAL+DegYxViORdZAR2gfzB5arF8LgCGAz0Q/L59UxbAKnh+BdNqgI5/AQf+RzlsOFCSzK4N4wzA+RniJGnshwGqmrT0fplMNSx+eSJ8g702g5gwKHIwr0FV3eF4csm+QTwquGT3VhUdjWrWeY7btNXmi2ZEPHPNwPrd/b1r/9syG3o558iXw72pml5+VUVHuAv5TaOZh3vSXfS+bqBxrrcvRQWpeYkhs06QYqAC1QIkcBk1d1+3V1TuFmRrD6L1fqHYoFPr7ms7w3gUF5IGaBfQd7Y3IpmBX2I0Ls9yx1hYM4eD+9iqxE7gfy+WPgGqY/zN4JHLyO6GeLUJ/UdMh5MjaByvyTWmz//yWrJclH1VHhwYaX1DcOV1ODJnWc7t5yBCeVDUT9ItX+7XdJaaOtxh7ba3VtA5d4YQSqGUxHnn5SyNg2RlyD1pZNRm/WNJL/zlULFYt1Soy89xmj1fra08fo+rOY+mWPeGNfJMZ0976vxOsomVnjm6av+IcPtCDu3oTw+5flUKAqudbqbPgRlRT1gxbZH73PJgFmldMc
 p3tEXAif
 dwwOAPmiyAMLKp8HTbXAoTQnLSialFDhOxamzo1TnCp525/q8mqBpsMm7Vw/MqQCDXmd0frXm1O7VkT+5H/I7amh8zei+uVq2dR97u3QWEKPlB2j0+3UC+aj1Ca9kRRLVe6HJBmodS3tjFP2x5fliMX7XUqcR0HyOkWp7sX8tY5OBVNvQAaAV7TG0rR8ITjVA1SubqU/8LK2M+UF/Hhatk3YPPWIapGzFwSFCkoJG09ftgbqPPKU0L3UWofxqh9velmotwhsAm4ejKmgBEQm5rOckTW9DTUg8hKYAlPPUDFtOjuI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 08:14:36AM +0100, Michal Hocko wrote:
> On Wed 25-03-26 22:13:21, Qi Zheng wrote:
> > From: Qi Zheng <zhengqi.arch@bytedance.com>
> > 
> > Hi all,
> > 
> > As Harry Yoo pointed out [1], in scenarios where massive state updates occur
> > (e.g., during the reparenting of LRU folios), the values passed to memcg stat
> > update functions can accumulate and exceed the upper limit of a 32-bit integer.
> 
> Is this a real problem without reparenting? In other words is this a
> follow up for that work or something that we need on its own?

This is not a problem (as discussed in [1]) without reparenting.
[1] https://lore.kernel.org/linux-mm/138d9363-ab0c-4f5c-bedc-b326f5aaee91@linux.dev

-- 
Cheers,
Harry / Hyeonggon

