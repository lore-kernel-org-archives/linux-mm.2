Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BBEBC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69D4D6B0191; Tue, 18 Aug 2026 12:18:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674156B0195; Tue, 18 Aug 2026 12:18:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 563466B0197; Tue, 18 Aug 2026 12:18:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 371D66B0191
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:18:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C93721C0089
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:18:57 +0000 (UTC)
X-FDA: 85114899114.20.4865574
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id CDFBE1C000B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:18:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eP8uekuV;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787069935;
	b=IV3hfNitJMpu5STClmlMuYqt7Sm9cI2KO2NbUZO4p/qMjrNtFJsNPFv20fCMIDGELXiPKg
	8w+44RnSgwTUJ3hsvB6LTNvmQpCJy6VupbraUUjNqCZ4ky7HvUavjvFEVneMEj4g7RZySS
	kIFDI5P/P8nVfgnTkpqDu+lxq+0Z5Gs=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eP8uekuV;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787069935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gVALxD+Jk0AOIz3aCbnG3b9eZCXqru9RBTp/G9WNOQg=;
	b=cRmt6PzX9YJBFwNwKVbIToBrWD1Snhf6PKTlOAPCH1eWZhhod/Quw6U8mOJosnSAptggVc
	h/Ec/y8VM6CYI/GdSqPB+6WC4yQC8V3l875YPU5SQWpRZia89vyQeY0Go5hxrcZ5Mt+hSI
	W3n/mV2CRAomFvCcP5XxKPnkAGhfP0Y=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47f904e80eeso4680608f8f.1
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:18:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787069934; cv=none;
        d=google.com; s=arc-20260327;
        b=Our2yiM4KQ1OowiA2+NUs2QuIs61UlCfbSo6B3BeuZpTLKiHPJiLvmikCZybfBtWfU
         /EwPTXunKSa0/iZ/ODmL0UqNH5LsxBbuyjUUXG2mGL1UeqP4LUars916XycVUOziA3tq
         KDzlt0h0Xb9rhHGhrXXMJ50BXUz559Qacc0A0uBweRivj+gPibJC9vp33DOtIz5O4qrD
         FtwgldNjKIRfrLcFGksR1no65lxxTvpKtC1v2AS3DUC5nPy9UIx/qIboZDVMtHgfx1IJ
         31AXSkRXgPWtkLLqNuyV9Jo4u+RJhZFprup/1BWuhUu1BHM4zOEuVpM8CWpbJUr5mmbA
         YxiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gVALxD+Jk0AOIz3aCbnG3b9eZCXqru9RBTp/G9WNOQg=;
        fh=wbwrhLCXyFw6frDV2nFz2Zs62tvGKBqJC7eKIPDFdZk=;
        b=cmuffTR2/wTisDVLT8WdRi91If9x3YNGwUEOm5U4wt2GHH01BSPHOclBnjbR5mQjQy
         PW/vhRusmKM8FkS2ZXsD3D1e4a3WetiU3+dsWQCq1SJSmoRenG7pdkvH9RFuYNfWn+T5
         z8zzrTWAN9C42Z6Dm7BVvqEJXfZhr6djd2G7Z4KaIXGL47YgLlo9bYTkp9zC+rRCQwQs
         6sKDBSYRNIkYKBNSTHUSfrTRZgi8QKtyoDaeIFI0ydaJy+tH2Jpnn4y/KrrCNRierQaf
         xoQVSLKFUA7KRWBRD9jnpApl3meJQiic/H9Ofjipcrt6WA6JN3cPb7HwxXK+x+sQVXix
         IpuQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787069934; x=1787674734; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gVALxD+Jk0AOIz3aCbnG3b9eZCXqru9RBTp/G9WNOQg=;
        b=eP8uekuVvdLYu4TftY4WlIF3oQzwqgIJcQaz9y+mxoT8OB6m+KgwV8+fMfktaiRoaM
         TcbSSHL7eK6KI4MzErGuv0w1t8RFwa2DfwkbyEduJSZnySYybKBUcCsZp7Bk6Whdqx8H
         6mW+QPRy9/pfqQQ2CiZcQbgeumHmIqJlLDHswvCDyAbXRn0b4TyxhI8Ks6p+38esK5ep
         DaPozZwd5D1/JVpuXkxCJM5hZoaGl1WmwdWudX5L1VsGpu74FKyZkpaRkQHY3+KJwjH+
         gBBdRxPX9P1cUlrPNp+uMztwCADOUtl7Rxs/ycqZmBv9DtNjoOJjl8tnDin2CFQ3Ge4w
         fwDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787069934; x=1787674734;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gVALxD+Jk0AOIz3aCbnG3b9eZCXqru9RBTp/G9WNOQg=;
        b=nfUKSi+9Q3Mdz2AWS/lDTFwN1VT0qIbguD/hav/q/ZwmxbaC7cs3EN7cW+hTLhOOpn
         NWZHw82yFMR8WbeJq4R9uaBTjFyjHaQMPptjjUoAq2i/SvdcZzfpEUGZCO6Z/cR6a240
         Z7dppn3IsfDhyYEvCI3oeSsn0j2wlJtBgUPxQUVbIGkzikiln78m/Q14qvNVZpFo60zK
         77tUOsKYJ8BAGYPFBLMvoN1edU2xfE1OH9BxL3mMRJD/4E7eeRNSfop8uvo5XbRSbnQI
         C0oWJBotW3vpq5ktAGBkg1EscAzr7VWfjqfBIWodb2SXrIME0qmrxIgQUDXhNkX2dyGu
         E+sQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqzy4cXJuANmxgoO34qNqAH78Ns62du+XHCUGQh6WsEKFSqN9p4CXs/MsKYFQmEFQkxDManBTEt2A==@kvack.org
X-Gm-Message-State: AOJu0Ywnf5H75EXEvELm0JPHhFZ51XVW+EGZClYkPTrkVHlOYtOpojb3
	i5Bv4UQkpVpOzlz5fLZtvIXujH3ybkopm+n7gabsdARW4ZCfFWRVhvBkZw5SlYYTQ9sSHaMepb5
	acGLWtioosd+6roAUg4ShtiFc7prlk1I=
X-Gm-Gg: AR+sD11O+0DA1y3llYq2MubBWlVMb8AsPH6fNfnh7b8OKYhitPtfB2EwycKmMRhOnBn
	XmdQH8Dkj7SlvUhmbE5eusceVBe7SfPZ3E23GRNxswBPCIihjDWmVCYpbxUZvRE+KSaUhI9wrf6
	vH0ojHRP0hZYOAagJBYp+xKD7F9Y8UxojljSNRF0KQ/xA4AGg1vhO9P0TXcJ8X5/T/6aSGFkVEB
	Ss49uhBM9pYlH7DcUYxkJxIOOcC0teyn0o3xz00w9fNZWPn3iR2N8M9HzjUOl5CBWM9mu+GFQky
	25F23+tj1YbME0589AsatFLmxR/BrtloNKLlMQoe4RFYPnIP1B0IBDDYiuPv1E9ZFUk1P3F6+YW
	U
X-Received: by 2002:adf:f2c6:0:b0:47f:97e9:fe60 with SMTP id
 ffacd0b85a97d-482a90c53e6mr14065626f8f.15.1787069934351; Tue, 18 Aug 2026
 09:18:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-swap-v3-0-d3fa52598a59@debian.org> <20260818-swap-v3-2-d3fa52598a59@debian.org>
In-Reply-To: <20260818-swap-v3-2-d3fa52598a59@debian.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 18 Aug 2026 09:18:42 -0700
X-Gm-Features: AcwNN1X15vDEjY5nPoiFHhF6Qdb7gOmqNhOG8Ze1nmpzcS-yhxhhbK9naUrr3AY
Message-ID: <CAKEwX=O7qQc1naHEjvUOW-d7CgA_+9Am_0jW1Y3NCe714xXtPg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm: fail the fault on a malformed swap entry
 instead of retrying it
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CDFBE1C000B
X-Stat-Signature: x7no86mkrenhqqur7eiyj5fzwcbpekcu
X-HE-Tag: 1787069935-7714
X-HE-Meta: U2FsdGVkX19TwyXSSOYNfr7K+IAfSsWsitajv3ARLo8IgOE/6WngaJMQxhN5leMql5CBPKecr63drul6umEr1PWN6AEYfPq54po0+rrTFOdwB5WaPAEdaUMDPCqLvcpvom9qDnbFa3kpeO0cvIzWd58ht8PN750O4SIGKR3tLR2aznM2cJcOHcET+5JiT+SRZcRCf5kVpZOUNTxkcA6FJGp8s+L4B/G0mLUVrxLdOVRws3kT+dwrbeu4md5EgmDiODTIkNyc5N8Rcvi3tWZ3eYiE8mVcJaxMFtiGO5xVDUFlb5YK1bBHqVZPCjZlFVl+VgB/GLYrm2ACpYqJCaZKqm5gUTjVpEEHdgZWtBtsxpYPbfHSD5hkmCUQ/hd+Vhr9P+W7E+kDj6H66r7WQwriAdjbo1eMAdcl+BTQqyD20GZIiBZ9u+0xnAT/ibKBAdCxPjtBQyv9Y7/mfmV0eFarcXQYKd8TKRTp60XfSxHco6i8xPf5tW6sDmSmPuk2TdB2eOPRwmtZxemXgTVAa+dQHYHwnT7mah8rnltbs2AV7PXbHYS7lsSTAx+4KuA+Mr3Zt8o4ArOTCpdWlGR5OSlW6mb07SNssd6pMhrsFt5Z9b36tbQvu/n9LDLWiOWBoLsloaM6NjBjZUyoWBIVDZ0Pa4MO4y5icPuPVjkpms+DR8JbL9YmOgy8mxjP5dUgnLLd5NlIhaEURcimo9R1d6KQF8YJvF1+bNQqMTnpEOcJLLM6Kg5R7kmBw+VZMDmFw6fT7UIG9twu+8xF3KfQR8NwkvtgWkOdPzGKDrKsXYcw/PqQi2S7BG5otgdSTRo3U1d2oImW0tDOQ5WkKgrm7tlgqaB7AYx+8IZHTh+pPCvGUNjtBL+P4vgZ661EL2P65ogBzzaiyLTU1PCu3CKV4qALE+GWXFxV6ByRUaI1DAiswOVn5pnz+C+/rZX/mmSyPKruwkYMA1rF+bRevtkyHJU
 Cty55dB8
 qVM31z7WkjltCBfoxgGLGb13sTvrr5U7KEH5VhvXILXE3JGXOCSQ35HnaeS7DrEdSvpPr/Mu3h7iDpBYmsattb0wgi5D3y3tCB6EWWwptt8xpUS9SDrcKCFo/AVlRjYGHQto4sxthp57es6iDjCMVvgUkj+2Jue9jp/P/MwOl1d8PLTodErqNfugxeV2V8YRQaru5aG5Gd5rAxU7xb3L8aWiWttd/ZQhpHW8ZfeQ35yfiRKY3Yk6Z+ybqjv6bizKjPdVnxFc5RnpXFnw3CquitnawwuhH9kxyVw8VXvmcJp7eaSJj7MUmfe5iNNSZFrAfss/2SaNumAtcpvw9qj9a29Ykm610CfxP71OdWmIYOvFj6jq5duIb5veI7qmPal+cp46LkkKHZuGWX8nfkPwTccxsdgQ/fcQQHM11g0eAIy4cu5Nq0xuXgEgmIin7F3iOKmb5ofEVR4487D5J/UdeqPoUutWVJakxuw0k8N8UTZgiHFMtETcpmdMOWxT8lgt9I3uaLVpDNRrCj24=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 3:08=E2=80=AFAM Breno Leitao <leitao@debian.org> wr=
ote:
>
> do_swap_page() returns 0 when get_swap_device() fails, which the fault
> handler reads as "handled". For an entry that can never become valid
> the retry takes the same fault again, so the thread spins forever,
> retrying on the same fault.
>
> Return VM_FAULT_SIGBUS (Bad access) for a malformed entry (pr_err() was
> called at get_swap_device()).
>
> Acked-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

