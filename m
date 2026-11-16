Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62E55606A884
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 10:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gY5LQq5U
Received: by kanga.kvack.org (Postfix)
	id 71A116B05B1; Mon, 16 Nov 2026 05:42:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F1716B05B3; Mon, 16 Nov 2026 05:42:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E0926B05B4; Mon, 16 Nov 2026 05:42:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E0AD6B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:42:47 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CABE21C4240
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:42:46 +0000 (UTC)
X-FDA: 85440643932.13.E87322A
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id E880C80003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:42:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gY5LQq5U;
	spf=pass (imf30.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794825765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dr9af4pJ/8zWS6vI+oqg5r0KIFPMXaVucU+qa3+/eLg=;
	b=XJMJe4/F1uhW4Fqdpuc8fIZ0ejn4TbOgcwHSJKWHxvXlkzf7w1OjBeejgwvyrQHdsuwmra
	mT4RvAfRhcw9r0wfREpbfr1f2uhf32gQCUHTVR71aY5gDu6YpusE/gpMewMr72Fxum/3K5
	WlTIXbeO3nrijcu0u4M4/3AW86t2IGY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gY5LQq5U;
	spf=pass (imf30.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794825765;
	b=ZqeRtXRoRiWzrmkDHm34jTX4WnSvH4l+n6/vebuv2fhAJ8ObMTbMU+XLLNiyX/DmqcARVA
	S9lEVlCGcS8TjxTkQaqIw10odAlF2TdnLK978S6iCclOCV6fx3QlwkcWx+2FUA6jtCh+29
	2p0CrQ08z+UqYn9XSMCGeMBGbcWWRpc=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bb64c99d2fso19581185e9.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794825763; x=1795430563; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dr9af4pJ/8zWS6vI+oqg5r0KIFPMXaVucU+qa3+/eLg=;
        b=gY5LQq5UevQ63bIBt9Jz/UFr8vgDidkpdYuuCB8dyC7QK4ooeaxJa7ysAC7eANdkl5
         AvSEhsIga34zc1gjJQevuOB/ChDiU74FrKrbHyo2KLMxBsKh68/eIYqk/cPR2otPqXhN
         vGbZIv7gASqAVNt/wB/+PxYypSvWLcVaVysEfSsyNwRCt02dm1jX8/JF1aGfUmU6xTVl
         7lLPqBz7moPkHTL84PDlt1/p+/3/A2+MZqvp8dKE0RvjcBmdzaxhtKHH9DsWc08zPzZG
         jFgyUH/xlKAmQDIo/9LFM9BIuOENmvL+Z5BqPkCTaIupzlMeobOl47932AKocS+mfWWa
         3C5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794825763; x=1795430563;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dr9af4pJ/8zWS6vI+oqg5r0KIFPMXaVucU+qa3+/eLg=;
        b=gu34hQRomHwU1afyOElb1PJuHJSyUuBBPD/yOO/RKisypVCiBUuD29sMLDD0nuY8X1
         8qqWX9/HwM2xZ7mK3mPqqOZcjsH0F7sbAbvY3syKDOFUEYrLPPMU/goohZorOljAG8qS
         F8MECHY4NJArP2ESiSZ43uMP2i9EGshIhCBbubu/hW9pw5aH5Bl14DGTdBLMktGVMVqm
         6WhKDjSqP7NFB24McMkOdwf9puq3mlzAiw3I150lKkO7l/17AuQy8bXcIvy72gq9D0Qr
         AWLsJseEOqi+qfnE0OI7tDfqV1wKbELbOTEcHyEXFPN8E71LVdCHkss0oknbRnq4eMPm
         lXDQ==
X-Gm-Message-State: APuU4Z9wit4BwHtb6SUoVOMfHsl982DWQqETdCu83heWi9JymuZ3Z+Cw
	6Qu47dClRPuKmD7klemvisQBzwxWwFC6cp+gmY2adpTCcgd8wKTtaepT
X-Gm-Gg: AYBFou0cYUTj8NxW/blqK/+C6GGLMNGs0TXjxZy/h35XDqJTFPgde/iKWdmkw9Y0u35
	PVpeYP7h30N8b4xGaOmbW3wt3pmhupy44a3pBkLIbjvhOqUNe61SELEd5XERf6PpZj7DU5rqSIe
	3GQG1w5qynUavg90KgHiBj7JXhmb03F13Yx76/hL3Y3qT9mkgVpuulBglnApsJvmMNqlJzAIaoZ
	t7LJ8aM5uaiANEMiyUZqwynwFYm8d1r73puw3+impeVcjKmlvOFAtpWATDYBSCw+WWDYYm02O0D
	RHrV0YOUoCY1NWnHW402mH/O5yLP7tMU2y3kZkAkMzgNssCqOKn/HM7Uk0mm3KqNHgVIH/wZrle
	TobdC6lYuRHZKb0VXXFAsAiL2AKJxQRHWNhkF2vSYLA1HSWX1jkXmSa8N1hpqI3QEGk2s1Xt3tR
	k54Zz+ZS2uKXl5btyc4dYlatmQgAzXkKDq+sobzDHZr3ab48uCf0qPvrZVOEWestFIf/lpkX6Ji
	VppL5ZcVdh7jaNE+XTQ8oBFvm6ZoPBd2r+fJsFPg5JYhYQjURFTPwoR9hSGHEUKPQ+ylKHhOI2c
	SM1NTKv6ijN7mQUoZgQKuVI5
X-Received: by 2002:a05:600c:468d:b0:4bb:741d:ea0 with SMTP id 5b1f17b1804b1-4bb741d103amr31960235e9.17.1794825763460;
        Mon, 16 Nov 2026 02:42:43 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f77fc47sm21618424f8f.22.2026.11.16.02.42.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 02:42:43 -0800 (PST)
Message-ID: <9277a849-0cf1-4a49-922a-f35aa36f1dc1@gmail.com>
Date: Mon, 16 Nov 2026 11:42:41 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm/huge_memory: only compare PFNs of huge entries on
 huge fault insert
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>,
 Roman Kisel <romank@linux.microsoft.com>,
 Saurabh Sengar <ssengar@linux.microsoft.com>,
 Naman Jain <namjain@linux.microsoft.com>,
 Michael Kelley <mhklinux@outlook.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org
References: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
 <20261115-huge-pfnmap-fault-races-v1-3-537605643f6f@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261115-huge-pfnmap-fault-races-v1-3-537605643f6f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mhtkcr9a83xqe6q6udusaim6wxs1mkcs
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E880C80003
X-HE-Tag: 1794825764-493450
X-HE-Meta: U2FsdGVkX1+DO1Y2fhi8J+bcAF4WxikBx9iZHfnu2QXqjFHHow/XH9kXNMKof1Isukepk164DgaUZzZ7F5hlbRiUYf6v43gQoa6TbF/wWAD+UP1luxIK5DYrfCDlmmFsFWHOl/DXMeMDilpx81mRlwy5Ap73EAo+XamHIOXvoFKm3QdXpISuX2GLTw0G4Hd4JGB4fH7FQ3dhDUSwcc3I4x/CQEumzPCMKX2kpJJ1hNEWBBV1fsRDGer/QbS6BX7mrtoPOIEfudVRqstjC+VpMw2QWVwaHfOYtgJtxoRtM2LvJDxJLyinYaTC8oq8Aj+qF8ZZSTXH46+RDX2bdw8SNKGdkV5DJ4M48ihMR+G5M7LG+vp9F47Q1D9mddAehe9j0nnjFB5unYYQPIHXUHSNRfyCVwiI7Obk6V7evpNpWDZllj17LTyu33DMMN8hxlDsas8koi6jVbxC6CmUAEgRcoo+UsiVzMHg2Ao2T/Ssb3qJjBwkpm7ImVl4Bgh74LV5ybY/nkf552URO6IVg+wwxuuT0KHd16RTg9BjKarRQ/lQwfDnphQ5F+9Vd+3b5lY/O6RkADHI9vU/KmtjkiHubfW9vdYWZzExbIlAMWBgbp7rikmXL/dxc5HlCJZ76ja8kVmFj8BuGfyi1XoKtCB+ynYUtRef7e8WPOodSS9G+dNXVAPDkBkNnel+tDDGtYeZcrDFo922tjB716veVA7927d2OV8NYw8GEsBbsSn8amWheEvgWycI/y+7jSKvjoba/1FpptInhJR0Sz1VB+8KgoxSrLa0w1T6EaTDQK3+/RoJ2DYYe5apotsTlAHx36jZQNQDJZX/yF9QytRcJtMZfIhoboCthFep2moawcTLawjafQSn08+mjX0YsEkyAhbAoSjJW6cKk06MIftQ/U+aFxj5Wx6RMuJELxK0TbDF5982s0ZVOw6xIbbNBG8Nt34zEmaBVXXsyppQgIpXpIR
 h33btG1X
 uo2N3xdYMMFT4T56URj8GDj1IIpx+bdsBdYKclx3F1xsyPiPKnXVwuVRd4jNXR3exKAzAmO9ah3Bmo4mS07TeM0kijbQwNUImer6COYa6+aLaWtAo7UFVI89xaPHGt9MBy3oYab1t26ewjPZN4uotTRw+DAm/5ilPOGMxsXZdEFCKEwcV0MYOF+1oGp+DS+593BjBZW0wV4K18jSID9q1wueEicOzWYLpFAt+qVRGChmcxT9uSbt8SbDGo6NAAbmJK2NH/wHczSX7+/THbDWlgD6ySL5B74zHrWoHcTlPSaOavvLIkSAs1soIcJiOn9JFRs7scQrO+osKsvFsbSkqfHRA3GEPfrBuCI31uzlHFOMjH3zv30PY4SPcpNnD7FrFjhk+d29mfx8hU6dBniqPWpJvgs1ndTuzmBEN6J5aTYK4U/TDQaY0ZdRitP7cJU9+ZGnaVZ11APrDShFbe5mZpRUktvusUbO6cwQZyka6hSLCtHZQCRWbk91wI530gAXB8NCkXm/l8MgetKJ8JPS4DCVnvwKf+RpjKUDYdRYh+SmWHEsC/aHk0SzUEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/15/26 9:58 PM, Lorenzo Stoakes (ARM) wrote:
> A driver that implements both ->fault and ->huge_fault must anticipate
> concurrent use of both.
> 
> This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
> concurrent with faulting, as that only holds the mmap write lock and thus
> does not exclude faulting threads stabilised by VMA lock.
> 
> insert_pmd() and insert_pud() have issues with this as they both assume
> that, if the page table entry being populated is not empty, it must a
> present huge entry.
> 
> This is problematic as if it is a write fault, it compares its PFN against
> the one being inserted, warning if they differ, on the assumption that the
> entry is a huge leaf.
> 
> Since the entry may be a page table, this is invalid and can result in
> spurious warnings.
> 
> Equally, the entry might be non-present. Nothing can install such an entry
> in the VMAs that reach this code today, but there is no reason to rely upon
> that.
> 
> Therefore only examine the PFN if the entry is both present and huge, and
> otherwise simply return VM_FAULT_NOPAGE so the fault is retried and handled
> at the appropriate level.
> 
> This is what already happens for a read fault, for which the existing entry
> is not examined at all.
> 
> Target the commit which introduced the first driver which both mixes fault
> orders and passes the write flag for the fix (since this commit, both
> drm_gem_shmem and panthor are prey to this issue).
> 
> Reported-by: Eliav Farber <farbere@amazon.com>
> Closes: https://lore.kernel.org/all/20261112051440.16140-4-farbere@amazon.com/
> Fixes: 7bfe3b8ea6e3 ("Drivers: hv: Introduce mshv_vtl driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

