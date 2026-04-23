Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EEB4FDEE48
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 20:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AACA6B0088; Thu, 23 Apr 2026 16:12:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0826A6B008A; Thu, 23 Apr 2026 16:12:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB4116B008C; Thu, 23 Apr 2026 16:12:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA7EE6B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:12:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BFF898C3D8
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:10:39 +0000 (UTC)
X-FDA: 84690913398.04.63F1868
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4BD1840002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:10:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=esHd+RDF;
	spf=pass (imf04.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776975037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1G8kt4KIcRoHxbZhKFDwigWKJXLBw/Au6uDx0Oi0Fg=;
	b=274YAvbpGRUldZ69+rxTtQcUhmBTv0x90FzjJaCGltk3kpiA1tWOE3vurwLmBZ6eVnhDXp
	KNc1bv3cT+w5Qx6acyrYpdWChreWRJMFq2Ek1eAvhiEaIHjVq0kEKGLTmqdg31lBbVcMXK
	nFdIvEgmNCLGNXxNTV+jPeDVtbVZSIc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776975037; a=rsa-sha256;
	cv=none;
	b=chq5pLYd15rqA0LADVpIh8hMpP0XGF7YaLHukKBbg+ioJbmR2JoDvM5laNtX2huCOHZjsq
	6jyZnQXnkDmkawjfgQKtW8qciHL++XDYYfqtYfDMEZt/XlQJ/gO3ROJd2x9n4/oZM4DC5n
	0hSTQcaXvBlRYNdSoU6ja4aIEFurvTc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=esHd+RDF;
	spf=pass (imf04.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776975036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L1G8kt4KIcRoHxbZhKFDwigWKJXLBw/Au6uDx0Oi0Fg=;
	b=esHd+RDFq2x4QyR8cO1UheK9aUGBLo8yhuGXtza8i4OzuxLgyBCJDPc84ZVP0XaS/BbErZ
	E/cOcOfWKu8q+BVpwkcugprg/ne2Dw6+w6dfvSSQotkoXqKJSMbvSqqDoo0dziA4Eod0CO
	vRb4WM3htMsk9ez6X8dNzY05BP0+6XE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-Ezg_ucRqPDKhyLp-JHMJWQ-1; Thu, 23 Apr 2026 16:10:35 -0400
X-MC-Unique: Ezg_ucRqPDKhyLp-JHMJWQ-1
X-Mimecast-MFC-AGG-ID: Ezg_ucRqPDKhyLp-JHMJWQ_1776975035
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8cd722c1a69so1276593285a.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:10:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776975035; x=1777579835;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L1G8kt4KIcRoHxbZhKFDwigWKJXLBw/Au6uDx0Oi0Fg=;
        b=aKQcK/ZwBw5ybLfaoc2xnqxVSSZM2j9iue3xskWiwhZ4CayXz4q5qy+JFx4NCKV/qX
         6NRX/+liJ+lMl1vqJ7Sxu8Ep+ytvV2pLt88Z6KDe+dk+PT9NBc+6YdsJiAtdKxNmZBVE
         WBTQ6zSxdTtlKpZAgIw3F/Xh2d6vBYjCZaRfN7ja81kqmcSATU8T1WpXYCa4NWQj5oA8
         KkloCDIw0ISJBIYHklt3g4aIVAridwIWYjVoc1IgKy5WmOz9zy4v/onb/xRAXxNOOlDw
         hnDJNShEBCkdnlBZCPPM1mg/YQuJ7ik8bIqdEseYCT1gR29A8JNKm+icBG8bAo5Uk3GR
         IVpg==
X-Forwarded-Encrypted: i=1; AFNElJ9gfdblGFeTpT83P/AGN7qD1kcixA11z5b9hrlR+Y4Iv/VyVnaDxabSbvJAKUtEST+XhcgGqT2eqg==@kvack.org
X-Gm-Message-State: AOJu0YwR+k0oo0DikqNC9NykSRPFAJUiL6N2J6Wc+6HdSGTAKwbD2qDV
	8kqU70z8kfzWh6+WA6xUx8f97uBdQm/K/wZluVw42uMoVJ7q+sddIuyJ/tuuRHFQ9heIoH5a4It
	R4g5YSA6h4sEGk6f5MX71HVbY1AmZRFxVYs8E9WGYwl/kFNrfr6Cw
X-Gm-Gg: AeBDieu05mkQZyS5KOeym9lZk4gZUNrkHdUmopH3WHUcfXtjf0DX61NxggB4nVRTDYB
	DchYJ679Qav4BWdgmGaM1WPDRWoRYBFCaT9b7VjqVZN7Kn/8jmGFtgDZiubQqA0GI5xy1d2kzls
	rZT/p8SEDZk3P2YGjQ4MQc1U9iurpI4+ubUL4/Xu2E3/mAVUju8bf+2SNA1qDQmcID+3wirnlFs
	+BlrouFbGkgA/3rRKLsQSNAAaH3yE3NBdLUqHTNRThnjWioQETo4wt+OzhrMpNgMbY8uqD3oo3S
	wFOXSk9qaSdcOqItNWXKlCE2U+J11NCXzSsZm+WlONpQKF4ynQhJB2k+b/OAxyNzrDQt/RhpsMQ
	H3cf+merzqoJET8d5AUsX5W8WFY/fqWFA0qwiIvY7R3Jfsn3LdQ4eCdAYkQ==
X-Received: by 2002:a05:620a:25ca:b0:8df:1541:d782 with SMTP id af79cd13be357-8e79236e338mr4156926885a.52.1776975034542;
        Thu, 23 Apr 2026 13:10:34 -0700 (PDT)
X-Received: by 2002:a05:620a:25ca:b0:8df:1541:d782 with SMTP id af79cd13be357-8e79236e338mr4156914485a.52.1776975033492;
        Thu, 23 Apr 2026 13:10:33 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d8edb789sm1845246085a.31.2026.04.23.13.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 13:10:33 -0700 (PDT)
Date: Thu, 23 Apr 2026 16:10:30 -0400
From: Peter Xu <peterx@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM
 guest memory
Message-ID: <aep8tsYFfr_Xe54q@x1.local>
References: <aeImfRrrvr3UoKtL@thinkstation>
 <aeTnlQUOOh-dHG8z@thinkstation>
 <34f75083-29a3-4860-8a6e-94551d37ac6a@kernel.org>
 <aed6fHLrIdahbdY3@thinkstation>
 <b77d559b-215e-460a-a268-e63b8273ef42@kernel.org>
 <aeorZMvKwu8zKX5i@thinkstation>
 <aeoxnuGKO3uqS2kG@x1.local>
 <aeo5IPpQi7onyjTF@thinkstation>
 <aeprnnccJeyHB2rt@x1.local>
 <17b0dc02-eee3-46d6-9afb-5f81a3a20216@kernel.org>
MIME-Version: 1.0
In-Reply-To: <17b0dc02-eee3-46d6-9afb-5f81a3a20216@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xMY9cKvSgXHbWapzhzXho4VSA4ApgBeokngsL6TgFVs_1776975035
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 4BD1840002
X-Rspamd-Server: rspam07
X-Stat-Signature: 4gk3de1f6zura98hembuzmw8f3b777c5
X-Rspam-User: 
X-HE-Tag: 1776975037-485106
X-HE-Meta: U2FsdGVkX1+3nRTtWtp0myQMrrUd1o7OthGNWAe9u5/y7dT+Ty2DeRK04eHZl5z/2YAfELGYcOJnGgq4SInwc1RBVEOZjzljwuc3h8gTZBIZgIAM31a4SDbkPUIJPYtZpEYBuIWm2qkPEsX5ZA8fgeUQL3kAqtjnv5ybq1ByM4Mpbpu5f1iJ33KQIESnvKQ41o3wxiyru7o9v0CLHfxcK7ZD/cnslZx+n91tljnuo+x4KoeSYeh4eniMk3WS5kSVlnL3dEkOhPQrqCc1KrMW2kJdZZmOCnRhrsTga3X+r4QEUr2bQcY3DMZeBgTvq5FCQXFiMM0icWlksGdmpe3i6G/RZFTmHOLirXmetTfUYN7dOLbAQ7qNMuYwS7/dO2g2GtgwKXJSBACl+HY6j7NHTav02WHSotK6xFP0YKGTx7FVSaW3P7ofNSoYuaI0x/TsFVLID+A34M2piwvAlQjtbpuBv/YZRVy47mgTGpH9qi7e37ntkQaWqps3f5xIln0mL2GpW4hoet/LLCX0/dBwwdnFRH9Tr5BoZ58raFQ6fAEj3cPlSJ7UAUeheBD6FHwkD1uwmv26rIT4VRl1DfuKuiAPHSunOtbJmq4Z+1jhogYFZUlDVIFDWEz+k5mETATMgIfj+hNY+tWfcOVWRvfEp9S0bV42Y9FZzjaXF6uHXWCmFuHaW7F4F/SfY0h/rNhNeG7Gjh93Ezo5nA/hmb+2eqmJiXmW8yi/M2wTHDnJSMuaxs3Qh+hXH664q/s4OY4ojkamvE/7NISHz43O0uHiZgfH7K/ZbscDSqe0Y0xlKd0BEdKDRBth1W98B+rwELPzd0F4HP5FzcaXD12HzhBV4j8sDXYzzvfD06BExk6W5LWmWYU13NGKjWocLxsvi0SPCUuLeyom6+We8lDfatkVUBvUmjfKKHIRowryCxPSDcn5wChKCClASXVR8tiQOPMmRN/4HT4/vMqK6QL5FA6
 s7FL6mu5
 41+ir/ct6JNh1G0kqlY35C0ZITrDULHS6IqL5TZRnNrHRdFVRKkVoLhLZXOCs9drG8jePk5COJPnNI5eSlHCtPl9fTtPy4F7BLvUwsxFumq4NFO4PdnaF+HNwGOcJwMnHfqxyNx0lj7hRF4PkPjQlDEwDwKa+InqsT72OrLXYI689WNaXgc3AzNOEHg/Rr6iQT1Kg3PhAhyEnBVhz7gpv6JZz0KBBgR9xuEK1abtkBDJYItfFebuykNekFa+d42zRv6COlYdLWWGANlJAn1KmioYjekAq7oNBuNMIBqGH7bcVwv7BcAJZI//PWj1QUhofX+YHvRuxH8xfpVNWW5f7I4/9iMgT3RVboPcniODQBuBIDBe6suUHpfU1VlITSw4Q8TGgDUKC6/OpfMMZylUyqyhHZZ+WqtsHpOAz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 09:25:30PM +0200, David Hildenbrand (Arm) wrote:
> > 
> > The other thing is, as I mentioned in the other email, I still don't know
> > how the current RW protection would work for anonymous.  I don't yet think
> > the user swapper can read the anon page with RW-protected pgtables.  So far
> > my understanding is maybe you only care about shmem so it's fine, but it'll
> > always be great to confirm with you.
> 
> I wonder if uffdio_move could be used for a swapper implementation instead?

If RW is justified to be useful first, maybe.

I had a gut feeling Kirill's use case doesn't use anon at all, then if
nobody needs it we can still decide to not support anon.

> 
> If we ever have to read from a protnone page, maybe we could teach ptrace access
> to do it, or have something that can read from prot_none areas -- like
> uffdio_copy, which can write to prot-none areas.

Somethinig like swap_access() in my proposal can also partly achieve that.

https://lore.kernel.org/all/aYuad2k75iD9bnBE@x1.local/

There, it was only about reading from swap so far, though.  But that one
might be easier to be extended to read PROT_NONE and directly put data into
buffer user specified (ps: in my local tree impl I named it maccess() to
pair with mincore(), but it doesn't really matter; it doesn't even need to
be a syscall..).

To me, the interfacing is not a major issue.  The major question I have is
why RW protection can help in swap system impl when we already have uffd-wp.

So I want to make sure the use case can't be implemented by uffd-wp already.
Because that's really what we might do for QEMU.

The other thing is I want to see possibilities of reusing any new kernel
feature that can provide hotness.  Currently idle page tracking has issue,
not only about perf and rmap, but also on not working with mglru (defaults
for Fedora/RHEL).  If we can split the requirements and solve the hotness
issue, then it'll also be very helpful.

Thanks,

-- 
Peter Xu


