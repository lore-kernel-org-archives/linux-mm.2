Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1686FC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 16:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5C46B0096; Thu,  7 Aug 2025 12:50:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65166B009A; Thu,  7 Aug 2025 12:50:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C05F16B009D; Thu,  7 Aug 2025 12:50:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AAFB06B0096
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:50:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A203827BE
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:50:43 +0000 (UTC)
X-FDA: 83750550366.26.FD0EC7F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A0F04A0009
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:50:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MGwS/KMi";
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754585441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/z1BPcl6M1IB73XeAhd/D3MnMo//lNmJfPInUM94bQ=;
	b=Fv9VmWtLFrJuvIDzBQMSZOasz8KkDlkyXxlV7P2SeMZ8lELb0FB4gk7HH4qcPYDNLZNxKP
	dWw9S6vM/MNF4Rwprn4LHNHyqMxRug/QrA2l4AmHDIzbJhxKaLkHZoNVbNGjOLVsFtwPAt
	hV/v9HWMwXppccs5nqMqTYZUIzOIoIM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754585441; a=rsa-sha256;
	cv=none;
	b=gnkT/zJ5J5tG4JDGPMo9MlY24wKNA27Kn0lK227PKAlFZf2e534U3n1CWZAcuAOstGSQJs
	0Hyq4Mf02aaMKd9X1s1Y3qJ0m7CwVDfGQx4HOZTf2SqgPmU04VLuuuCPoo9nl6hJDH4N1N
	7+IYJM9c9690HamLzEFfVdUzUdCED1U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MGwS/KMi";
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DEC3454FD;
	Thu,  7 Aug 2025 16:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4832BC4CEEB;
	Thu,  7 Aug 2025 16:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754585440;
	bh=Tcehrj422Dz/EQcSNUSZg7gsfb0vJ8SAd8MQ/B2zkxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGwS/KMi7R9jL0LYkH1LCvWMRqQTX2ZCXn4MwEOGee1Yxl5JJTsrmrL3wQ+98E4KP
	 F4iteIvihDPwcYUgOqqABPXxOnf+A+iH/6eE1bKm0bGSUFkpsQjNXxgrg4/Ctq+Mvu
	 il6hOFBj0dbA4jAB8szg4VFOItBIS6qPQWNEiNUNbO0kCgj3eW0B8jWKEtKcJTEzoV
	 vM9cjxWPbUEEFWpaqs8QOX5iOYouY16qdFKx2bm7u6i1Gw3g3DUZdiLGaKdNamWOLG
	 YcgPHN6hz9dGfIyc5Wg0fbcXd/Glg5NAi+rqpGbSvhNfJLIW7gHJs82RG7SgLYQrJS
	 WHw7ajwmIXrvA==
From: SeongJae Park <sj@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>
Subject: Re: [RFC PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Thu,  7 Aug 2025 09:50:37 -0700
Message-Id: <20250807165037.53199-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <2fa2f288-bb82-4a9b-8dec-3a4c768fb970@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A0F04A0009
X-Stat-Signature: 3qze1bqigqax31i5kkhcr8idnkq5mdpu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754585441-40779
X-HE-Meta: U2FsdGVkX1+yWFPglWpY/5UteUgFMfDVyiEqYlVVXZp7630lxz+rIi/fbcZ0v3at3iS1xbr3ywxa9Ei38hSahazVE+n0xDBmeeH2jtTACNpX7Rg6yoHHSPGS1NIniz9F+K5Oxhvk0i2gBQIMoSwCf6iQv8UA+tcRO/49Sf6NqkSQ/mC+LQbpMdUPzXeevaKSg0yiaJns2X6FrVM+rNiH7FsUVfI13BT6O8ZosUK3IRRzGxTuvIw5/uaLbGyhY8OYqALSpIfSrpBaadx+5FcSeeE5I7k+N0/JxQ+qdw0oX9qU0j+0lLCNran2qAteBXxlkZO6GvesQtI2Afw1SmS8f0ru5jRRrZa27/wkMqWeGshYxKLlxEGbmPMhvbg4qlnpIt1I1/9YvA5P1oy6wn0m7c3Z1eebsy0Fj+El0RaTKKQMhnOiH2ZZdYS69gnBdmpNbHjtT/jkGaKvLn1Pcopq+Qf4nth5j0+CvKdiJ2rNlpowEOslvkUBpLWACSAdQF2oIP7CSUrnNNqnWB6rdtptMxJ0mpZ16GGHzoOhGEY2WgRiNulq+YmYLQL1PHdpH7KRQh3Mn2JzjQ1KoJfEe3O2Ipz6V7rvdwylQMbX3nTQB+vGrG1CYBxzIRQA9tRfkKuLJlhSvSukCvkux7fm5/ytaIyAuLKYaBY9ZV5jIbYm8a5a05gkKI76IvAdZK+Uw3VfhDfv+0gg/+VvI1Y1evFu3MPslCz7pH1TIz1qnEnxGKVa9yY11AGFD7d/iatscLacjuUvAc8Ao48RbNRUb5yy9SempmkiV2vwv3vgGR+JTYYQOQg26mosYgUnMB4DhwIGeB/QKixTiWcuESOX9T32Kuqd7JMhvyr+cConQp++x8bFGYPZ3HcTZ+F5lQj1tgHqrAFsq52YMaRa0R++FzaPIumnruizu7zZJZ2ikuc9SL7yn3mELKJekP6wpohcKDwf7x3EOzoDwdzgh+8k5Nn
 DlGqV2PT
 l8ocZSkUfY+bMgMXNKNMpu8b81XrqekcUYaIf6SvxauQmE2l0r0QVh3myzzBlZmc2I0oRTyuLj8S4lhK+xJw18qs29RpLo6Qgkjo3LD+Vb/lHZe9RnI+F/ncoWIJ4OxB/sxShl5alCju7oMvQl/jBDl6pLnK7DxPg00sjnTM7OAnXfa13/CpNxJbJ+8dgnqpIci2sWIY+3VIE/a4W6mS+3HQrjMBCsrRSkHioF65G4XPGIB2mP1x5D79v+YZhP74pCOwufyEeFpzHfkdkudMkanpl0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 Aug 2025 07:55:27 +0200 David Hildenbrand <david@redhat.com> wrote:

> On 07.08.25 01:48, Shakeel Butt wrote:
> > On Wed, Aug 06, 2025 at 10:14:39PM +0200, David Hildenbrand wrote:
> >>
> >> But yeah, whether these "as is" pages are movable or not is a good question
> >> as well -- in particular when zsmalloc supports page migration and the "as
> >> is" pages would not.
> > 
> > By "as is" page, do you mean the page which the reclaim code is trying
> > to reclaim or the page within zsmalloc on which the content of original
> > pages are copied as is?
> 
> I mean whatever the "dst" is here.
> 
> +	if (zswap_save_as_is(comp_ret, dlen, page)) {
> +		comp_ret = 0;
> +		dlen = PAGE_SIZE;
> +		memcpy_from_page(dst, page, 0, dlen);
> 
> IIUC SJ correctly, in case of zsmalloc "dst" is just the same page that 
> would have stored encrypted data.

You correctly understood me.

> 
> If that is the case, nothing should change, really.
> 
> Thanks for clarifying, all!

Thank you for asking this important question, too, David! :)


Thanks,
SJ

[...]

