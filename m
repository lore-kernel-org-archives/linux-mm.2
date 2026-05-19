Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9B89CD4F5E
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 16:27:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDDCB6B0005; Tue, 19 May 2026 12:27:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8F2D6B0088; Tue, 19 May 2026 12:27:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7D046B008A; Tue, 19 May 2026 12:27:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C46956B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:27:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5446540576
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:27:25 +0000 (UTC)
X-FDA: 84784699650.03.BDDDA48
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 667A44000A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:27:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="mQ/UeYNZ";
	spf=pass (imf07.hostedemail.com: domain of qkrwngud825@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=qkrwngud825@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779208043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5usbpjdW6V4GRZxIENdpTSPGB2A/F8Hn+HvhpsraCUY=;
	b=iIszRMkZhIXClN+HUo4oWwg7zCVuOBYiZM2lws/g3TldEea963flQrjoxrpSVBYrCqHz7v
	wXibK/OS+8KQ3UQxXRg+ro4AwybJNN7nxvXDa3UK75TJqa5EsJQkBhEg9kXDjX/GlSpyi8
	uz/X2S3gmotUs1sij5cs35c6fbQlDGE=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="mQ/UeYNZ";
	spf=pass (imf07.hostedemail.com: domain of qkrwngud825@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=qkrwngud825@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779208043; a=rsa-sha256;
	cv=pass;
	b=aM7/LViEICTq/ZZwy+bmcANXwB1m6abF5t0u13tWJvrpC6tWct+WUb1pmyffFEpcevg3zQ
	sykqV/Ek3gAYBCEr6+/rqVF6fFGK9Jn+gZBWnwp44QJbLe24mTd8k7f++VV4+LZJF6hhgE
	BPQKgsI06ytHetXChjt+jGhfhaO/4KY=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-67be871ed3fso8541651a12.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 09:27:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779208042; cv=none;
        d=google.com; s=arc-20240605;
        b=C5fIMmBzmZklXnhtxOYneiT3HChZ4+3wqcErElbOoGcwNpAwB0KrYbvWwfMz3XnwwM
         DGrrP4hFLGgFLzghhl4+z6+DKPN9a0KqxtzVv2B4/8sX4eN8xSSYdZ9SOsfAxDx07Wiz
         b+Exhva+b124SLkOua41kqG1Zf35Qb+2uhL/awy/62SvJThz+UfnsBJ9hFAbzZWpJh37
         t6rhSl+tXLKqd+19x6KlWVBCON0+6mF76HtzXCZucjejL8FP+aJZdMVvTIApDCfosDfy
         k6CZbNbGL3x1m7A8XZ1TjkbPT/WDOwNRYT+3ffpzx39tQLhwHmlmFsdt+Bv0beOtCdSl
         nuuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5usbpjdW6V4GRZxIENdpTSPGB2A/F8Hn+HvhpsraCUY=;
        fh=Nv8y/c9hD/gGFZmfmXabg70HsjUsPqun5M7XOf9ZWog=;
        b=ZMBBUFNenNu4BcBIY5zH3vS1NJijdiXg5HJOoSz2yyzD50wxP5o97ulOe7dlC2fjjQ
         dX0pnUuN7Qc3/ntL3D9F20CSSPPZOlJpONAXjdlRHlNk6t03Wyjbrri05f4VeuRXw7bN
         xDWkdmEvRhoK3UgWNbHBJrgNbR/qoCoPl0yOTxCYm+tf0ichcWgMinHVOPkmkbL21kUC
         4sqB2tLUtNrTa8+kIBTrohr0lAAHV/6EXBXbjZClAFUph9CXr2O5Xh4qFFniQ+CAQDs0
         0HAMIpzXpx2wRgRMFDpfc1XWyPn62p21v/p089BM5a2AtPbdlwaIS03OmNiemOIzLjF2
         I+ew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779208042; x=1779812842; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5usbpjdW6V4GRZxIENdpTSPGB2A/F8Hn+HvhpsraCUY=;
        b=mQ/UeYNZV1EcOGADoaArkphTy5sOwYyXPciJ75d/BI88piGF+311defWZF3Dko8xrV
         y0ooRVz2q3iexzxNPDE24N3ZSymM34eIpVzlN2NLhbKXI0ZZHjqdf4Fh9vrVM6qg6HxY
         PBTNp6ugXsyA7Xbt8L84sC/0MPLdWoGnYMOyVe3vAw7oYevvZs+WWH5YxE3zwm2yI3DW
         XUYBYZjz30e5ibYsp/B32Fz5wlvQXBtI6HNSl1G3bNjwU32xPgwHx/8VkIKwYoAiDlPB
         THPKVHQwLFzGBulgp1fRsTON7SVyohIVsYJFE8MwrMbgtNF5vDXg0YnYO0KcC3mZHYz2
         Cv+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779208042; x=1779812842;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5usbpjdW6V4GRZxIENdpTSPGB2A/F8Hn+HvhpsraCUY=;
        b=Py8KLVtlDSubSsXsJmudhUXG6MXDGW4KDe+gmbKSe1+lI29wVwrsM5wATmFn9y7LXa
         yE1bOc1rsLr9eWqGyX0GFpSRrCNuBljJBVabvXBrUCZUuO8HZoZgFNcDLlD0qiwZ7Trg
         uOrQlCekkqapVnbwqpMS2JuXJkjr5/oXLkHnO5Q7vXkINEe0Vgm+LimgiTjHbk4RjQv+
         IRXgFPEjtG7aUwnvJaARN8Skwcim+9d3+z+1pnr9O6bruj9GaOCNE2EzZl092GW4Kduv
         SShdJowrpomSVGy15Z8alpTQnjZCE7vgUkv1EMKDXsuQgmMzxq5E4LX0m+QYaPcltuoc
         1aIQ==
X-Gm-Message-State: AOJu0YznrZ9rSQ0tUZKtSJzQwHs282UoWNxVcBXxGNQbsnFFpCDqrBL5
	fQP+lFYktWftZckUQXMZQc8uUogWGR8WywCSs2esI+6AEF3GNXmUcuqIpjEm7qWNWWfkCn0b/jo
	HUpOWAg9/3K3Gechtihmzy+KxrkwuAdM=
X-Gm-Gg: Acq92OHdHJb38De5I23YKvtztBSG3zqXTAAhEV+q19GMNnpSuk7uZR5C6brubnup0Bp
	iB3KjprjMoYP/e/8H+VXK/D5vUEttYxCfRxACjmVFCBTI260Hh2tpJ66UqnKT+FYK3rbAeknfff
	hH7H6Qwdgkgcaohru3k4jkY/KO7W6VX54qa3Jal1/Y9SfV6VoFBKdqqGdPETkkVJWf7lByVAfTI
	C+XcXFweNLr8Gy1VbjgfVESXQw/qOKEP3aEx3FFig1s4wqCL3G4bKY52oSFuls7N7W+kciojE8f
	THlx7JTmy/S1c2Zw9Swg3kdv1c1C70YQJ+nem9R0
X-Received: by 2002:a17:907:9719:b0:bd5:2a43:b471 with SMTP id
 a640c23a62f3a-bd52a43b4bfmr929160266b.48.1779208041621; Tue, 19 May 2026
 09:27:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260519151008.1399226-1-qkrwngud825@gmail.com> <5d00b63c-1802-450f-8e54-8da6c0aeedc2@intel.com>
In-Reply-To: <5d00b63c-1802-450f-8e54-8da6c0aeedc2@intel.com>
From: Juhyung Park <qkrwngud825@gmail.com>
Date: Wed, 20 May 2026 01:27:10 +0900
X-Gm-Features: AVHnY4LdRR3qD6dMJRp9P0dqGJ2iwd73wpIsKyKrAimUaQe9thTXgPYirbbLgfM
Message-ID: <CAD14+f2p7D6eco+-O0X6zWwi-XaxGLs0nQKDAC8eVWhQmB1VhA@mail.gmail.com>
Subject: Re: [PATCH] x86/mm: fix vmemmap leak on memory hot-remove
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-mm@kvack.org, stable@vger.kernel.org, 
	Lu Baolu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	David Hildenbrand <david@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dan Williams <djbw@kernel.org>, Dave Jiang <dave.jiang@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org, 
	nvdimm@lists.linux.dev, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: g5ohet69sauz6e8yafai16jigdu6bbar
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 667A44000A
X-Rspam-User: 
X-HE-Tag: 1779208043-316379
X-HE-Meta: U2FsdGVkX1/N0pGynoKjHTjm1L9kEleGjnGm9h7c64pB8ObLA64WfIQNlR4qt97FkrCMlGIsL/UIKyMoHErOrK7G60E3h00GnU0YLXJvxiTmVq0y4T1mJNXbmiNOCd5+a3/HyRgbclkKhapsUzF5ZWYTWFGqN8jz93znTYS98j6fQ9ELc/WMdYlDpd3MuVkN7Zqmd0pAL7Mpkwx/bfpNMF0mEZ6eTUR5txxxVaEbJQYviu0UGuskjYIry6VIIysWwr9IBMbXhqlZeKh18Egu6l4c72WrcUMXVpi5ukjmtMfQcAyaFUGZWEQvOmzykK4DjxSgXOG9DU/u4687UkrfPt0R9zzDtJHxFlkF33zhEcScrExy6qgwn+y6XxPF4SvATFHmTp+dJUqBpjXeY/FPkRWI2iOvkIQDQOGZ5/MnFmfiLB8gq0zY9cLe+9X+JSVlyZFlUabqAwsUll1GoPzty7pOBZmKq2fJy+jC9ixnQCA1DsLI5On3fNLDn3kq28QRFWv4t5dUPtyReU2S34sXnRJ/PUP+Sr6eRDmK8IRhylJ2LzVgowwL/Yxe/nsm4pAqBIbusbzTOK1ouNERCnT87LhAH/mJ0lJ2CM+ZtXHcyOmDvuSzYFutI/p1pTNIJfnbgtYfxPovdSbk4OYWr5zyOhFjM9mitX0H3KtIjc7mmKygX+q3Xi2ZqdnGBbkecdW6xZ77K0tT5msJu7T5PwT3QxxW40KcMSwRczngtKr+JldmDH+5ERGRYWNG/pxSoRH8DeB1Hn89DRdUpZCzy8g3iD9ZALZ0bx76I9Y1FEGA/bxLSZxL4CFLFyczBjrLk1S7cyfBf4qalecY4YbKm0mk2TF98BltPJVJKzSAnXFjHR58pb84tgBT0CCOBNAC8yPmBFKh5jN2LJBjy+yNrAuPs6zwe2hkC9zjn82wgaVLwlkyQvhz2Tx2luHOh6uWOPN95gsjVq9oIfHHuGNUj5p
 VxBMEE+4
 MA3DLeWyRP5yuBOp+TfnZIApRiUPnePZEEHR1I5L8ZG2gKI1Mn91chrEwkjIesc2VI2z52/GnoJJP1omqNhIPXFjTmtIcP4Zdi19Mn/pBy4XndNMfKG+pWsL++dqGpu2MdOiuR3O+OKLyA5qZrx0+9K0vSAvp6COj6Xo5JH4XYws82i748XymXquL73kMujom8BiaT/ikXI7PpByjYoAJDijL5msioHoRFumQYPQkTIqRPYvhcuKWcw9xI1OPHO5AqjSSl2ZvpRgzZ/RADxKEvrOQP2yv3VMDHImXnsTKj88ffu4oxANN1wN6emAuuYldaZdv9IH+8KuuVN5l749iZ+K64AMw5cIcBbHkbNlNLFq9cSWLgPZUF6TiCNnmcXUyzS8aBU2GakU1CnnJ4p56N8FVS8bvTM/DgcWIGpVzcaTkUS6xf+kWJLoTPRQTGKMLh3KKW0qAvaNlebWrmYi1AdPUQjpaQsLHg4Nd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dave,

On Wed, May 20, 2026 at 1:02=E2=80=AFAM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 5/19/26 08:10, Juhyung Park wrote:
> >  #endif
> >       } else {
> > -             pagetable_free(page_ptdesc(page));
> > +             /*
> > +              * Use __free_pages() to honor @order: vmemmap PMD leaves
> > +              * freed here are not compound pages, so pagetable_free()
> > +              * would lose leak 511 of 512 pages per 2 MB chunk.
> > +              */
> > +             __free_pages(page, order);
> >       }
> >  }
>
> I find myself really wondering how much of this came from a human and
> how much from the LLM. Could you share that with us?

Not my first kernel contribution, just so you know. (first in mm tho)

I asked Claude to write both the commit body and comment and it was
too verbose. I manually trimmed it down.
Sorry if it still sounds too LLM-ish.

This was tested on a VM with virtualized CXL device and toggling it
back and forth was visibly causing leaks. kmemleak was unable to catch
this (rightfully so), so I skeptically asked Claude to see if it can
figure it out while pwd was the kernel source the VM was running.
"Access the VM at "ssh -p2223 root@192.168.0.185". There's a memory
leak whenever CXL memory switches modes via: daxctl reconfigure-device
--mode=3Dsystem-ram dax0.0 --force, daxctl reconfigure-device
--mode=3Ddevdax dax0.0 --force. Figure out why. If you need to reboot
the VM, do not do it yourself and ask me."

It did in 6 minutes and it basically told me to revert bf9e4e30f353. I
was very skeptical and reviewed manually (with my short knowledge of
mm) why this would be a correct fix.

>
> We're trying to get _away_ from using the 'struct page' APIs on page
> tables. This goes backwards. Worst case, do:
>
>         /* vmemmap PMD leaves are not compound pages */
>         for (i =3D 0; i < 1<<order; i++)
>                 pagetable_free(page_ptdesc(&page[i]));
>
> Right?

Shouldn't I worry about the loop overhead? With order =3D=3D 9, that's 512
iterations. That's compounded to O(N) when the entire memory size is
in consideration.

>
> Even better would be to *make* these compound pages.
>
> Even better than that would be to use some 'struct ptdesc' space to
> explicitly store the order, just like compound pages. But that's
> probably not trivial and probably not great for a bug fix.

