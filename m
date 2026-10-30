Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8165B606A322
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 13:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XCKFnD79
Received: by kanga.kvack.org (Postfix)
	id 736B86B00EF; Fri, 30 Oct 2026 09:48:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E7986B05B1; Fri, 30 Oct 2026 09:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D6C66B05B2; Fri, 30 Oct 2026 09:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 318526B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:48:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF1E0C06CE
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:48:08 +0000 (UTC)
X-FDA: 85379421456.03.D93C7A7
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id E2A3D1C0004
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:48:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XCKFnD79;
	spf=pass (imf20.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793368086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rmX4JEwV7qAmy43PkgvX967p02rESGhBBxr09gc4cBg=;
	b=cS70xb3QEFBEGiVKpnwUVFRK2XvZO42CQkIaIObVOLPXbfim5xle0kzYHz6TFmR6L9pZRC
	qRZ7brCJNXDZKldmLmL1yY4xmhgXLxt+3/qnOKwfko+3+j/3YixFNjOgmjJTjQ4Tk1T/PG
	5MNBKQUaaeMaeSiACPLcIXcELRWi0mc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793368086;
	b=O2H8SxWvl31FreNzXy8ubmKANx94YW6qS9wm+Oazx+UG9o6ogXUH/8EgzXdvrjCDTLnKpb
	FStZaCYohpcIZOcrYNIMGGjuTGgRXYTW7eQRt3mqxZ+z9zKOFQibfa90WSYz5+Nw7z7xvA
	uXChu9k8nCHsO/YjIOocOlgZhAQILmk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XCKFnD79;
	spf=pass (imf20.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso4832715e9.1
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793368085; x=1793972885; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rmX4JEwV7qAmy43PkgvX967p02rESGhBBxr09gc4cBg=;
        b=XCKFnD79jzBn4ai1PD1wwLqPHba8HGPqnh9t3jEWMAWitTtiDOLcjMQtOiFKbrt8E4
         boDZgO+hUbgpaTsnkQz7jr+F03HfytOJb6xo7WHqg/AfbHA2mCZskrXTmPjUpBypAChs
         PE3Ech15H+fuYxGwxLf8+5XfqizddtuERCHevWvRo74Mv2xUjQ3iQtHHMd+7W+gN8cWe
         w0R8AHWa0DdBm0t14UhPT8usxaDSBAD7l3BgERezAummODEvkT+/voBehBgsNrtM14Qh
         9xrNQC/afVMzMkpcnZr48VnItywBR7cumkDOhH7W46KtwQzgYjQYz6CdbxB24PbLtC/W
         AN2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793368085; x=1793972885;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rmX4JEwV7qAmy43PkgvX967p02rESGhBBxr09gc4cBg=;
        b=lqRNo9fU1RJEb1penxw1sI+vOUmDdcdLvH3hyOQ25B4nD3XvEF+sH3nvJ6dbZIG3Ep
         wkZB2QKlIZrS9c6+hJlnxUVadkTgliU1i1oVrLw8EYPctTP3fQwCJ2+/udZ8ERGfFOlF
         DeFsBlnp7fPXufn+JnN2pRLlVyXWJuVb3Hs9UkC/CK38v/dY52VsZGPuiQZ9xYuVD3/n
         A71IoIePs15MKU9xcGF3IAYCGJeRNu9cCqPn7lzu1TTgpF7Jjw54gjOAxIWHDRxSCPpV
         jsLMqZrjNEiDc3R+jED/Y5jkSAD2FB0NWMbathY+dskSiXvhxN0rpjJZgiA2qW1J1ETx
         TDJQ==
X-Forwarded-Encrypted: i=1; AKwUvBwBjoa21zTHH1NmDyQsB3QjgTRigx3jQVIFDyGMiuJAjjoOo9j0uho37iGyUWjN+q5IEZDjXOFArA==@kvack.org
X-Gm-Message-State: AFq9FYJmbCsHUh4xM08FTR4CH5vAVv8bjM1Jrm6BAwEwxDcFb6ODfIpz
	Hr0H7LGU0w50MuLtJRUZNn7DOW1Jn6tG2/9T5EQl9f1rOV1slm2lmECk
X-Gm-Gg: AYBFou2JQrOb9dISEpBaFbgsdLOF4oQm5Feb419iIXIZgrd9/BeNFmUQJsnDDRHcdrE
	CL6UweGkt3VMJ/3QiZSlmZQB5sSOdMifibTAHcrMGNOQ2poDt4KCRFp+/RQk3zyVMO10Sf0LGo1
	6ECZ45KFfDSiMXBr90t0JRMmK66hD5prVPsELVRszBXMhIDOWdanF4stgKaILd/51pF7P8O5FGi
	Le+BcR6H5RVioDn9FvSdwzNDEGFkdlneTRPp183fFXl+9j90YepsKJW3iLYTCV80A5xxouMPG7G
	rlIKUNTCpYP0W6cJQL0pJM+oGI3wbc3DIwxD9ffVwFoVuHcRiU2vhR9PGfASp4d8IPtPYUYME4G
	c1MbiZPGrobmLTaP2/4zdHe9KVWAcPE6/jEH0grRzm1shn6Hv1LsfOIdD3PpjSRj0xFfOXbRASm
	CXff252NgjpWJrUVeoj/xNO+4OT4LL1TxWT5WD3vyRXR0IfoTkaaTRtqCwLRPINpTULBDk+0uHF
	fpwXD6wd0Dl6KoAV+DeVyOLKLkERfZifAJIZLC4KUE4s1Dan0W1+JlI+bNJTIEelqQM0jvJ5dPd
	kjOerU7FdYX3AbG48dXIZLHvqmPoSEar/uwjBwfyYibTzzAQlIXlqyC/uJ7fUVsLrQKYWIV13OZ
	Xd0YAz/ElOflbcw==
X-Received: by 2002:a05:600c:34d1:b0:4a2:526b:d3fd with SMTP id 5b1f17b1804b1-4ac1793fb5emr50752935e9.15.1793368085145;
        Fri, 30 Oct 2026 06:48:05 -0700 (PDT)
Received: from C422HJQPQG-Fractile ([130.43.154.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ab69b54742sm172048905e9.15.2026.10.30.06.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:48:04 -0700 (PDT)
Date: Fri, 30 Oct 2026 13:48:02 +0000
From: "Vishal Moola (Fractile)" <vishal.moola@gmail.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Alistair Popple <apopple@nvidia.com>, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	linux-m68k@lists.linux-m68k.org, linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH 0/2] mm: Remove pagetable_dtor_free()
Message-ID: <auSgElFWW4n3sJLb@C422HJQPQG-Fractile>
References: <20261030083800.599152-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030083800.599152-1-songmuchun@bytedance.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E2A3D1C0004
X-Stat-Signature: 7bcyoo36wywnp11kiathtaeiashom8g1
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793368086-983289
X-HE-Meta: U2FsdGVkX18ciXp7Wre+bGlekKgQBC5ze+m3ZUrA0FVEQQQ3VkrYZOiDBH9Jc3m4hyd/5SgEFePOblmsrzN5UiPiD3+g6AbeeLe2J2gP2iMs+DV91CwwGT3onNB7eY9bLJL+OC/K3BBjVFhPbFCNVR4dShahk+NTLOcq4xYfSYgLMW1JR5q/9KX+09dl72hQ/OwrJrp2VDdUM2j9bdsL9ykFWG4GYyrIkvFGyhYwlC+1TxKH88y1W1vgIPT3Cmd57DSCLTJbeNBm2JSGRYaYpGELyLzYyZrnvcSQ87FtPS9rRkjM5KtYIittt/4aqEii2CdbpKyIPXhDF0zvnJ3zDxiLKzkqsNoFs9Vu2lFAQn58TgtfkbAPPKSdnMVWXqwbYPPLVaPZy3A6SQLROyAaalcNSI9OmX8p+686S+3MjB1PDlePxYK7OSPzJrNjgByp02tPnadEmxDlhGdKPfcKGOusJKfOtjOTyoauWrfFIX50VlZRT1L8G/DxYlY4jRZHIkR6cZUlnHG1rZMnWm5gnGcLzoEvnV/abRczAOp9JjZ/mc1pGaFQatw+XoGdavogoodK5gbYEbeUQld+qg8Jsi86Nc5BsoOq6T4anli4lkOuT55LzIQXlx9Wd9cW2hY7maUm1gT06Q0LuasZAuU74zzcQzWheqJ9dDnVyqbYxk7f6Vw1TOHkRXI0sIb+v+DPvLKj7f1j+rz3Nc/Ec6srIrC/kwnKjSUwKYBJ7+ZH8odBKl8zybixpUZNaU/D6EtK9u0dcm53Bi7DP3qHwGTpp+I1dO5AME1CZWPMhfqJQIlH/hckp3KZhkNMbCOl5ZgDNn9PzkiTpKM4VqE3xYQRvskXGanxlKFVS3G6mrVNpL7uans/4GTeSfEg0+s86fA+GPV+M3Vj1tu0nhHpvjvPaA+VaMu7dQ403Q1dyL5eC0a9ZUbU9xTnTiDSXPbnBYjvyckiyl0ucmb+/qa+3zl
 pTU6Wt2N
 Qn6YGzETbeIXJ9TXRxafSsTWZ64AsZs/fm2kuu5L0KIEKxQmSJiwjzmELPdpGTMbC08GVc0LGqtyYc+ru95tAdv5fMw08GkZh7p7J0WqLbclcoAsufXYH7drWQhe+EL7h2pRrY68J9DkkIokuQ6oK0pmUkzx+UV0WAwj6c4rQwikVd/0/tLyY7qA8iNCuc9+8H5lJlTv1Y3TqnkM3/3rUuKvd6XJd0rzKpsEcg3vm5jATSP7UerkmfTP2nhWsfMqM7Vff7iEFkLNDOo9sT6F5cTVsRk8z5lFXkCz+JWdVUxYnn/k1e6KuQ8dDTVWlXC1d/hnqNqFr0zARZKz3WMTCxqdJundUjVz8GBENIuw7ffdsaeA0pmqJEvYMClJjv5ec7/PT9i7x/wfHTDUnJoZ1a0OSgi5t400KZphH3CSQQnl2T4Gnh0ivvwMYD7V/rXgqN4cc/RNX9TUbaaSo5L8EULprkY4s2KQvG1wOAW+pvdcqVqPnuJEEE8i9iDBgzxVLjHyuiLV6IOg+7iKpvVcH404lIcdX5OKAx8gP3NJ0khGvlM16lxwHPjXWTQt5WY8NeLhQ06KJUMbnnWOjdLGm4RsUdLY8YPPllJPr4Y5VF2Tg55tTg4swGnQoYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 04:37:58PM +0800, Muchun Song wrote:
> This is a follow-up cleanup to the page-table teardown fixes [1].
> 
> pagetable_free() now invokes pagetable_dtor() for constructed page tables.
> This makes pagetable_dtor_free() redundant and leaves explicit destructor
> calls immediately before pagetable_free() duplicating lifecycle handling.
> 
> Remove pagetable_dtor_free() and convert its callers to pagetable_free(),
> then remove the remaining redundant pagetable_dtor() calls. This keeps the
> destructor decision in the common free path. No functional change is
> intended.
> 
> [1] https://lore.kernel.org/r/20261023063428.3658761-1-songmuchun@bytedance.com
> 
> Muchun Song (2):
>   mm: remove pagetable_dtor_free()
>   mm: remove redundant pagetable_dtor() calls

For the series:

Acked-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>

