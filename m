Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 016DACAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 06:23:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DC4A8E0012; Tue, 16 Sep 2025 02:23:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B2D88E0001; Tue, 16 Sep 2025 02:23:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A1808E0012; Tue, 16 Sep 2025 02:23:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B7D18E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:23:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB46511AF8B
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 06:23:28 +0000 (UTC)
X-FDA: 83894121696.18.438FEC4
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 07295180003
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 06:23:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=StbGLQPM;
	spf=pass (imf06.hostedemail.com: domain of hughd@google.com designates 209.85.219.170 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758003807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jzwxSCgUK/3UElXn+qMCVZOXd6lLimgLpQ+KrGfwqaU=;
	b=vGBRotFqFIvLeWF2ZywiaXJDeCot4mSJ7Kix3oaPiQtYQx2HoQvVCKo6Nim39dOjDGa4Iv
	3LfNSxOY8suSPb6nafwzdObpmUAqPqfILldF1jACgxR3iEWyAIpI4/qq2TftYHwrWbSgt3
	Dq1x0lR5Zqjfr53ym7UvJIW/co5vo3E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=StbGLQPM;
	spf=pass (imf06.hostedemail.com: domain of hughd@google.com designates 209.85.219.170 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758003807; a=rsa-sha256;
	cv=none;
	b=nLxGx28Lw+usD+sf+nmQMWcIuF4MzJiFGsSP1YKV5o3rNefjvbSh0rFt19tJtY04lalrxM
	nd6yUwLH9iyQUHvkScJqTcAcjCYh+oIvHZdmkKG6o4wRsl3YF9WK/6tuSBy6xSza04fUJn
	zuFl4bRDLFLOtAMxubLmucoysGOGMLw=
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-ea3f49679ccso1823270276.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758003806; x=1758608606; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jzwxSCgUK/3UElXn+qMCVZOXd6lLimgLpQ+KrGfwqaU=;
        b=StbGLQPMsK9uyEP2xd+n7Q8xA4LS6tjLEaZW1c0T7tWCUyZokDDeYld58BiNj4vxTd
         hSSgyZaFSlLbxglfkJ73RDtNOv8tUHq0+uk4iXLithU2kxe8hSxX6k7QiSHk4coNajHb
         Z9aL4RXMRQQFN0VcsYpZiBt3o5VW7HXbQi4pLBRN7OFZk6N5wEPU+5OkSbtum6zGXM1+
         VQIe3g+G1/3yQAIe5kOkoLb60J83ptjJRk/KHSyhPkXWyLqIjpKZ7VxCkQNsf5GMbdPF
         DwaT0Js8QU3jM+yQ4q/tFbd6Gcn41plsdtIASGMnVC46tEhJWROOYhGRvSXp8TTWZvhu
         xKTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758003806; x=1758608606;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jzwxSCgUK/3UElXn+qMCVZOXd6lLimgLpQ+KrGfwqaU=;
        b=QN2Es6mzjXVeeBQY9wpB87SOKJlTDLWq9H8nftilTVyOaX4eTqpYrSQYLG9JZbTrb1
         y4miJGhYRwVePgqBzlTHrmkfovN6hDnn2hgkRda1IGN4N3aWK06ePyHuSuiCS7l7wY56
         IQZSP1yowdj+/eP+VK72aQiK6qK5u5aLJuxvLdvAevcF1BPnz3SBILKdJexeaArzIDcV
         C98ZZByjEG5xmolj730HIPf7i3hK4779xPUu70aOG9n1z395NfqRqLDXFPxCJVf1WMwY
         sY/we2iDRXV+fIpXGW9jk9sP/0GQVnE5l401NvjOXW2sXCfd/xDVbYE515Nt57LFZGJM
         ir2A==
X-Forwarded-Encrypted: i=1; AJvYcCXwgOmnpMGYoD8OW4NVG6Sd3z/+kOvFmSQEfOQGCAZrCFEVFI9nr2/aIhLZdBwM0zLbhgIWRnqwRA==@kvack.org
X-Gm-Message-State: AOJu0YyPsbC+KM03M5SYqHeICge1rmBxUK9ci6TW06GoHb8BmiBt+RN1
	ryeu6/oWE0HhI8AYKrtu+kbxWfp6tWxjRkQijKmt7l+0yDKTekFQqG9i5lW4zhtyoQ==
X-Gm-Gg: ASbGnctPGgm2UTG6s4aghKmPsOLZlUMgqvl5jOfwoWhZbXi9qECjic+hquE1drDQIfY
	CWVRQqeLmG7iHGICdZmr38Q2t/fKeM7vQa0k1b5fpLtk7fAoYAoph1siXV9N54RidnDanb8tC7b
	P8fg2yCjQ3QeYJFB7jmHk95Kr1SDLGWXaRog3lK0GxqRq3YH+3LhT+xXNXVwp0WnW55QgnX+n8J
	8r/KGK5wgf2VHgwagtLKIet7iU4eCCqOMykqq4T1lbG0hwPWIWsQV3F4Gr5Mv8ds6Ogob4aag4D
	9dBby3cxwi/h3ieXvP1cPq7FDed+mXzlq3DSOZeQRI0vWU1hOmEmOnql90fI9QGnPFkAExV33GK
	VphZbo3dFEUziTt+iG+kwyVfhKTz8Ym3GHNgfeKvs3LTNtkmT4FsrmtDRNTFAXtAWZ//WENkcEq
	YTAHuJihVKNxZIBQ==
X-Google-Smtp-Source: AGHT+IFYH7nKR98YSl0bgd4j6elLmVBr5qc5bTleI6LMDXL64/KgQAEWWcRI4ClTxXA+31LnE3T7pA==
X-Received: by 2002:a05:690c:b13:b0:71f:eb2b:83e0 with SMTP id 00721157ae682-73062ca43c8mr138095197b3.13.1758003805348;
        Mon, 15 Sep 2025 23:23:25 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-72f7683148dsm38488107b3.23.2025.09.15.23.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 23:23:24 -0700 (PDT)
Date: Mon, 15 Sep 2025 23:23:17 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: "Roy, Patrick" <roypat@amazon.co.uk>
cc: "Thomson, Jack" <jackabt@amazon.co.uk>, 
    "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, 
    "Cali, Marco" <xmarcalx@amazon.co.uk>, 
    "derekmn@amazon.co.uk" <derekmn@amazon.co.uk>, 
    Elliot Berman <quic_eberman@quicinc.com>, 
    "willy@infradead.org" <willy@infradead.org>, 
    "corbet@lwn.net" <corbet@lwn.net>, 
    "pbonzini@redhat.com" <pbonzini@redhat.com>, 
    "maz@kernel.org" <maz@kernel.org>, 
    "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
    "joey.gouly@arm.com" <joey.gouly@arm.com>, 
    "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
    "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
    "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
    "will@kernel.org" <will@kernel.org>, 
    "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
    "kernel@xen0n.name" <kernel@xen0n.name>, 
    "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, 
    "palmer@dabbelt.com" <palmer@dabbelt.com>, 
    "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
    "alex@ghiti.fr" <alex@ghiti.fr>, 
    "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
    "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>, 
    "hca@linux.ibm.com" <hca@linux.ibm.com>, 
    "gor@linux.ibm.com" <gor@linux.ibm.com>, 
    "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, 
    "svens@linux.ibm.com" <svens@linux.ibm.com>, 
    "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
    "luto@kernel.org" <luto@kernel.org>, 
    "peterz@infradead.org" <peterz@infradead.org>, 
    "tglx@linutronix.de" <tglx@linutronix.de>, 
    "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
    "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, 
    "trondmy@kernel.org" <trondmy@kernel.org>, 
    "anna@kernel.org" <anna@kernel.org>, 
    "hubcap@omnibond.com" <hubcap@omnibond.com>, 
    "martin@omnibond.com" <martin@omnibond.com>, 
    "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, 
    "brauner@kernel.org" <brauner@kernel.org>, "jack@suse.cz" <jack@suse.cz>, 
    "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
    "david@redhat.com" <david@redhat.com>, 
    "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
    "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, 
    "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, 
    "surenb@google.com" <surenb@google.com>, 
    "mhocko@suse.com" <mhocko@suse.com>, "ast@kernel.org" <ast@kernel.org>, 
    "daniel@iogearbox.net" <daniel@iogearbox.net>, 
    "andrii@kernel.org" <andrii@kernel.org>, 
    "martin.lau@linux.dev" <martin.lau@linux.dev>, 
    "eddyz87@gmail.com" <eddyz87@gmail.com>, 
    "song@kernel.org" <song@kernel.org>, 
    "yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
    "john.fastabend@gmail.com" <john.fastabend@gmail.com>, 
    "kpsingh@kernel.org" <kpsingh@kernel.org>, 
    "sdf@fomichev.me" <sdf@fomichev.me>, 
    "haoluo@google.com" <haoluo@google.com>, 
    "jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
    "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
    "peterx@redhat.com" <peterx@redhat.com>, 
    "jannh@google.com" <jannh@google.com>, 
    "pfalcato@suse.de" <pfalcato@suse.de>, 
    "axelrasmussen@google.com" <axelrasmussen@google.com>, 
    "yuanchu@google.com" <yuanchu@google.com>, 
    "weixugc@google.com" <weixugc@google.com>, 
    "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
    "zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, 
    "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
    "shuah@kernel.org" <shuah@kernel.org>, 
    "seanjc@google.com" <seanjc@google.com>, 
    "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
    "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
    "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
    "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
    "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
    "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
    "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
    "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
    "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
    "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, 
    "devel@lists.orangefs.org" <devel@lists.orangefs.org>, 
    "linux-mm@kvack.org" <linux-mm@kvack.org>, 
    "bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
    "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v6 01/11] filemap: Pass address_space mapping to
 ->free_folio()
In-Reply-To: <20250912091708.17502-2-roypat@amazon.co.uk>
Message-ID: <7c2677e1-daf7-3b49-0a04-1efdf451379a@google.com>
References: <20250912091708.17502-1-roypat@amazon.co.uk> <20250912091708.17502-2-roypat@amazon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 07295180003
X-Stat-Signature: 4sbikyu1fb1166uszp94q4qd13igem77
X-HE-Tag: 1758003806-493786
X-HE-Meta: U2FsdGVkX1+mCh0ra3wJ0Q8FiGlQFmov3pKLe4jwhWnhgEjwmsloU/LOaw1ubKteueVTmaUgLnUlKo2CJN/oA4ffIxrU5/7BP9vLdC6QIg++pamff9In1jTek5bboJcBI4/xT9Z7VtkiahJBDfDdv/SYPAk29YnKKuRWoJgqF5NlixcrEPSLZob5HTfJIpf5bLI39OliDQhqrcDvDnbCOY3v/k6bG4zAMHQ6nHiwrBJmt+N7A+zSg5DTACHtfeEbrWaPhavb4yU7nYqVQTV4mUP1IawL74rBRS64nWbIBRDjcIBmSczx1Dg10WM8LtLlY8Eq2MqNIN4QsDWcpxchmkEBdjiA7q4ymUL9R0FkRQ58hybiiF/6a0Nc4S7K5iVIyC5UDAoUkGbJgbrFSGmfewyfmK+MahPk+LEJcb+T37F1S9C7yXKAJozVaSECX2yqKZlt5dcG9naClhc7eI3Av10Eehz7quSMfecthDcc+yOCUfsCjd4g4/a/boENsvhjW3EeS+lmyl0FMe5qDSdB4uwAt14YojYy34F0eP4eOpS6z7S1ZkUX01zvBkpKyr83IA0MTY4cK4iF+l1Gpl+8x615BMcs08z/dyOZBAS4TDxvinkWVImHxticwGUUQBkM6QqsYUnzoc9nNtAbmyEQNBXl8/Z06HZs3NuWpqRd+94Wf37WPHHIpIzKKc1K4cpC+d4FPxRfA5TUJnzD18YKQDd/bdQZM3bCTUgmc0gl1jZFa7wML7Zjh26mFQBu0zassc6XCG3nTvrppKCWbew1u93HsLI+BxepE0zC+TukJAoTXopt350KEjrkdNnD3Zkwl0idIksgFVCuRDEfvz2Zc95YFQhDdYeG43tME/WZBh3VqS66gOLUmvD4+trs4+d+jphbhTv/SFdwGATbbzQRAPpqK7hM3InTyHVM5UVcv1meW3dzZ4Djsq5nq15FmqiU6Kg3RdWyU3AR9ed/72g
 dcZcohsM
 k0cr6mITRXmZoqsgMbQOa2s+ca7un/tERxVyuNMjgtYOfpcWKUnxV0YgoyjM6ECBs1c5PQ3RFnxtXUTsYjDNC5dBMJBQuTICR+ms4/ZJhrOsYpil3hRB0abdczWtWDH92bSssJ4SosDYS2kEe//kkfdPWIKpM2Mx9w5GCX6PepK0c2mGhyn71FPt5NQJ48BXf2My4ivXg3AoIG2FpT6jf3lyq7OKAC0eNCRgvX0aONgugWWgIl+DsnaHBQ6BLKKecE+3dBB6mkibwl6DqfXKZn9OIAwX90pv8NKQPHof2TDNPPWpF9KRKm9BhRlbO2gLo7iM/1b8p8q0mfNlSCl47+EL8zXH+6EAum3IasSwdx9B5c9V99GMdS3tQ0gZQaBsNDWdOxeNIFnbN2HKyUTDd89/BVt8hHaEoAkBcAMEwt04lPff3pRuQxP6ZuhDfdBuiN0fQzvWbtcozDOuNK8iVabKocn1xf9C4+Gg1n7i8BC9YcO4rkDK1R53lCemiJ3CvzaDeEuVbAZKCwy8PJpkCX9QJQkXiyORGP4genwKdfrtUfDmL2nkfObbrM5ijLEjNvXGXrCUTjuxfpedJpdwG1hfwOoL0rO7hy2v2XSOB3mugqfNnb88aMqo50JwIK3PSW7g3FruoXs5PmzE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Sep 2025, Roy, Patrick wrote:

> From: Elliot Berman <quic_eberman@quicinc.com>
> 
> When guest_memfd removes memory from the host kernel's direct map,
> direct map entries must be restored before the memory is freed again. To
> do so, ->free_folio() needs to know whether a gmem folio was direct map
> removed in the first place though. While possible to keep track of this
> information on each individual folio (e.g. via page flags), direct map
> removal is an all-or-nothing property of the entire guest_memfd, so it
> is less error prone to just check the flag stored in the gmem inode's
> private data.  However, by the time ->free_folio() is called,
> folio->mapping might be cleared. To still allow access to the address
> space from which the folio was just removed, pass it in as an additional
> argument to ->free_folio, as the mapping is well-known to all callers.
> 
> Link: https://lore.kernel.org/all/15f665b4-2d33-41ca-ac50-fafe24ade32f@redhat.com/
> Suggested-by: David Hildenbrand <david@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> [patrick: rewrite shortlog for new usecase]
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---
>  Documentation/filesystems/locking.rst |  2 +-
>  fs/nfs/dir.c                          | 11 ++++++-----
>  fs/orangefs/inode.c                   |  3 ++-
>  include/linux/fs.h                    |  2 +-
>  mm/filemap.c                          |  9 +++++----
>  mm/secretmem.c                        |  3 ++-
>  mm/vmscan.c                           |  4 ++--
>  virt/kvm/guest_memfd.c                |  3 ++-
>  8 files changed, 21 insertions(+), 16 deletions(-)
> 
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index aa287ccdac2f..74c97287ec40 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -262,7 +262,7 @@ prototypes::
>  	sector_t (*bmap)(struct address_space *, sector_t);
>  	void (*invalidate_folio) (struct folio *, size_t start, size_t len);
>  	bool (*release_folio)(struct folio *, gfp_t);
> -	void (*free_folio)(struct folio *);
> +	void (*free_folio)(struct address_space *, struct folio *);
>  	int (*direct_IO)(struct kiocb *, struct iov_iter *iter);
>  	int (*migrate_folio)(struct address_space *, struct folio *dst,
>  			struct folio *src, enum migrate_mode);

Beware, that is against the intent of free_folio().

Since its 2.6.37 origin in 6072d13c4293 ("Call the filesystem back
whenever a page is removed from the page cache"), freepage() or
free_folio() has intentionally NOT taken a struct address_space *mapping,
because that structure may already be freed by the time free_folio() is
called, if the last folio holding it has now been freed.

Maybe something has changed since then, or maybe it happens to be safe
just in the context in which you want to use it; but it is against the
principle of free_folio().  (Maybe an rcu_read_lock() could be added
in __remove_mapping() to make it safe nowadays? maybe not welcome.)

See Documentation/filesystems/vfs.rst:
free_folio is called once the folio is no longer visible in the
page cache in order to allow the cleanup of any private data.
Since it may be called by the memory reclaimer, it should not
assume that the original address_space mapping still exists, and
it should not block.

Hugh

