Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C957BE8784C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 18:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EF4B6B00E2; Tue,  3 Feb 2026 13:16:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29DA46B00E3; Tue,  3 Feb 2026 13:16:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19BD26B00E4; Tue,  3 Feb 2026 13:16:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 00E276B00E2
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:16:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C37E0D5262
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:16:22 +0000 (UTC)
X-FDA: 84403950204.27.3FC5052
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id E28DC8001A
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:16:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=AHwBL1zE;
	spf=pass (imf02.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.46 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770142580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mu1la4UZlbEX7cvXzj/Z/hgnRFrqjHU+qKtYtW0dmkY=;
	b=iHzlRdxJYvmeNChbXiheOCwQrQOBB+oTkoPsVKogcK0DdeoY8DaVcgzOf6vG9sZFdX31Nn
	7LyRbFCv8vMYWZnW+FO1MVQnSjrHOhbVS1oUYHL0HcnKDongxY9cUpzGYl1QXBsylCwIQU
	82evDJMLzbGcsAriGqz9BD0Iv0bznVk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=AHwBL1zE;
	spf=pass (imf02.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.46 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770142580; a=rsa-sha256;
	cv=none;
	b=VpRqxXDP9MCSEtHjOvJovd/JYxm/hdrVhzqzgPb0tH/h5jH3SQM7gtOyq+PUE9np8lknZS
	R++g/QF0Cg1TXX03UfHFt8b7jes+tBqG4O3wnI42uBeQsOWtGL7lGK68uPa6ab3g2rg0zI
	Lk2BLfXYtNkdriUomLsryAfJUakTEoI=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8947e6ffd30so70834926d6.0
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 10:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1770142580; x=1770747380; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mu1la4UZlbEX7cvXzj/Z/hgnRFrqjHU+qKtYtW0dmkY=;
        b=AHwBL1zEUUMbLLEkD8fKkPMrRTj/PudT2zZ4QCLmdoosnUNwcShKRPyhIIRbJZ7EV6
         3HdWrHArhLEDk44n0/AugZGiVZ+gLEIxEAnzmJpLXEpM7YKVx6PfqgkbM6F6NINx/Y2u
         XHaThYnALHvxPKmE908g5eXmgP1OIK3jGGLKVS6SsJmAOdLmu5/Z68Cs5n8PO0aR1W5w
         FDtk83FBjz/d3HptluMyfIc4+oc9qTIV+hTfyBVNJhcLVjxpTxLrQRwDO+5piXMmbvZK
         SVBmLvavm3IxK6fRzeEFMmhfcLhpLG/yWicUBbwVyOPPNw0CtInN2CinC8vZEaeZPkN+
         T9kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770142580; x=1770747380;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mu1la4UZlbEX7cvXzj/Z/hgnRFrqjHU+qKtYtW0dmkY=;
        b=eSNAPIH4JOG8WkJEew2Dsz793Mm3g8xeqtIGUSTg4aPfuufI0d7C8316MsMHraUmF2
         vItwFwhudzBNdpAZIjRd3wHViEQM4ckCfGGZo2/7rwatrVCixOWViIweuxLHMPTLlpoL
         FsU7gkCoUbO38vNxQafH5nA+c5feUkpWnuTMEZhYnARI5Cd+RA8hmuE2nokWXVMZ0zIQ
         kE36ejRLi6OqQYeCZyG5wfi01xeN6/kaAM/s0b4RP8dBVWbMMi2m5eTFGa5W9En9+fMI
         ybkLrrgY2Ms+bJLy/9TgWnIU/K/OHBqCglyJ8pbRuEfVVtgC9LJSoxLqrKEODN8ehNNB
         g5oA==
X-Forwarded-Encrypted: i=1; AJvYcCVPWEgILctGdb2myorJ/z3/n5EjGmCWs/XkybCDfE2YoJUImXUQUZvQUxaGCgNXwVBJwekd3dTtHg==@kvack.org
X-Gm-Message-State: AOJu0YyzEYLSVpj1RBz5OPFIC+KtztSA51Qgd5bVjTdWDX++DOTEoRhO
	djJheLOPkhAhTN7DSJLZJcUDDAwGny/ujgNm+sbSs6tow5h8p0YZ7N24ERJKdrCVRhM=
X-Gm-Gg: AZuq6aL4Tf0O30Dx0iGiKSEspRwcmU/bDoPNqh7h3TMcP7v1XlQx6Td36Tu/MoB4hq3
	ZFFrfkhtRIn2yU6WY41a7/m890p3iZ3lvxNf6khlCQUOAFzoYc7S4JSUpynUbWaRDqpkEMoXPR/
	7AU1Mq16QaNJx7RsEBvMq6HAyTAU9R2SlIErtutvLcj3FsOxScwiGKV/3GvmqOEww79BadMzbf8
	Kbo1UW6KiSdjuqqUH0R5QLa4td+AyRTXkYJLDVvXzymZuJH8DHBK0PSK1mbkQ9YMv164zjgqwo1
	aGJyvuVoo5EJ3gFzaKlV7cOr09m0E80Jdt8GWhHfhhRjCZQ+43L2UnSOVOIoF5Wu8SqOQZ1gbUZ
	tcom7+Zv/SZBc9YNbcWi2miDQAOmbKH1zcxEwDB+DzxkVDdgrhf26xL0S5X94U2wX0dd8wx/ADL
	fzdBzZCZE8SxRNKzvJEaeGlMOBCaWwBfTOFK1IDM1Fg+m157krWz4iKxlPhdc4s05bpFQ=
X-Received: by 2002:a05:6214:20ab:b0:87c:22f9:dac4 with SMTP id 6a1803df08f44-8952210b4a5mr5192876d6.15.1770142579616;
        Tue, 03 Feb 2026 10:16:19 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89521c00173sm2728446d6.12.2026.02.03.10.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 10:16:18 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vnKwk-0000000Gah4-0kfw;
	Tue, 03 Feb 2026 14:16:18 -0400
Date: Tue, 3 Feb 2026 14:16:18 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Alexey Kardashevskiy <aik@amd.com>, cgroups@vger.kernel.org,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, x86@kernel.org,
	akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de,
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org,
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com,
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com,
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com,
	hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com,
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com,
	jack@suse.cz, james.morse@arm.com, jarkko@kernel.org,
	jgowans@amazon.com, jhubbard@nvidia.com, jroedel@suse.de,
	jthoughton@google.com, jun.miao@intel.com, kai.huang@intel.com,
	keirf@google.com, kent.overstreet@linux.dev,
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com,
	mail@maciej.szmigiero.name, maobibo@loongson.cn,
	mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org,
	mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com,
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au,
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es,
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com,
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com,
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz,
	qperret@google.com, richard.weiyang@gmail.com,
	rick.p.edgecombe@intel.com, rientjes@google.com,
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org,
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com,
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com,
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com,
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com,
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org,
	wyihan@google.com, xiaoyao.li@intel.com, yan.y.zhao@intel.com,
	yilun.xu@intel.com, yuzenghui@huawei.com, zhiquan1.li@intel.com
Subject: Re: [RFC PATCH v1 05/37] KVM: guest_memfd: Wire up
 kvm_get_memory_attributes() to per-gmem attributes
Message-ID: <20260203181618.GY2328995@ziepe.ca>
References: <cover.1760731772.git.ackerleytng@google.com>
 <071a3c6603809186e914fe5fed939edee4e11988.1760731772.git.ackerleytng@google.com>
 <07836b1d-d0d8-40f2-8f7b-7805beca31d0@amd.com>
 <CAEvNRgEuez=JbArRf2SApLAL0usv5-Q6q=nBPOFMHrHGaKAtMw@mail.gmail.com>
 <20260129003753.GZ1641016@ziepe.ca>
 <aXqx3_eE0rNh6nP0@google.com>
 <aYHGVQTF6RUs7r3g@yilunxu-OptiPlex-7050>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYHGVQTF6RUs7r3g@yilunxu-OptiPlex-7050>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E28DC8001A
X-Stat-Signature: cy7uttxbncnzu1dfpaixrss5s3d75nqg
X-Rspam-User: 
X-HE-Tag: 1770142580-663761
X-HE-Meta: U2FsdGVkX19wklhlJ4UTlmzdGuhKur+Df/yxxdHaU3+Z1NqtlZ5veqmOFxfGoN38kG24h85cH1FlSoP/kriX88wFEqXYv80486xELO8CF+w5k4+clwlG8gMM0LDJg132gmB/qyt9cm5DsPTwGdSIqk7Fpnkc2rqiX3/ilypkz9lTkqkK/Ku7cIDmCkzztOKjDCBomeCFafQUhw5ds8gehxngka6Mt2MrMMFQr3z7nRC9b91DngLg2nSssK9GkcsJiw5QWrTIruwZ+lv0mejT4p/X1+aqIfNtzXyy/3AmwEFY4WqKcigyq4qBBgUuANOt8DWl0IJnCE+/K7C3BaskF0Gq/UlB44DCtfLTL4cNpPB5mVnsZ7hz8HotIpdC/o9QIzf/zTN6d6lYFh53eosthA48H9jyMq4CL0UB1Nd7gTJHiYaKZlfreqBIpU1BfWp9RA612fFvtQG0g3Fs4jkMapVE3tSkbL0hYnkHIkAs5NCuJyH1LwLhQ1e0NvSCpk2o9hjczFvQLQz62ay738KjvblBwFdEMnnY181nktx9aWKWDaZADVSf7r/G+Vczl14lYPCM60nMWi3HY0twC+91D7sEn8HTS/Ey6qhQXMZ7EZPvWFbFbj14YrSde6T5klxxo8ToBxTW7lQ0P3fllZR1lPt/a0lynUqvQr/JCGPS+0BpHDGlW8zUwOhrbRIpDRU8oci5Y9fuqqkxdKwalELq1/PTTNp0nmhYnvFhCfeNDLnlcQGARo5sv9qZbHd6L5ofNU8Ju238V12yKeV47zhfeEedlZ8iQOOGrrF9AnxA6DIWggWcb21pmLD03WUEpuRu0IQEW/hW8eCuTKrs/a2PWaA/za+uzKolueO3DzVJdta9NsBqxSZCdH96I3V1yOS0TZFAvvuZpheCHlqjYxkUmJ9r8nilw13Nl7rxNXzEWpP0r4S8Q5kzh31Y0v7eDRUJGcnIdbEeetVugcbAaKj
 CJxheSMu
 D/ZMKoyRSK9rpEd+FcAsdwdTMlKhgJ96yZ2lqsOxgdJZ8NlOYv0Iq1OO/aexPSeBDej7gtvzmzy5Dnc+tSbzkIGucORlrEztvOurLKB6k/Flgktm+oQXr/M8p/2PEHy5E3ZDUhz49nCjP6qI9JaFwMfS5xtoHiZdQWS6w3wWbPYNLg0RkpPUgR5ryDM43gtXoVI+JpbkPJiJ8SNJapUzRy+Zi6Wv2MS/F6WfkTJYuwFqpHR1kN8Xn5rsp29pd7kACeHfPr7u7vFpUegiqBJExgLrqp9XtG6Z7ODiIqWWICnmuwBornvMh3ue1l9d7FaaqLQHCtdUbMBh23dwGKerHrPRbpocjVRxUt7xgiDgmNqcmWQHT0MrnkrdVpAYFmQcdRMy5I0L/YS58SCg+G+9hOqgxIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 05:56:37PM +0800, Xu Yilun wrote:
> > +1.  For guest_memfd, we initially defined per-VM memory attributes to track
> > private vs. shared.  But as Ackerley noted, we are in the process of deprecating
> > that support, e.g. by making it incompatible with various guest_memfd features,
> > in favor of having each guest_memfd instance track the state of a given page.
> > 
> > The original guest_memfd design was that it would _only_ hold private pages, and
> > so tracking private vs. shared in guest_memfd didn't make any sense.  As we've
> > pivoted to in-place conversion, tracking private vs. shared in the guest_memfd
> > has basically become mandatory.  We could maaaaaybe make it work with per-VM
> > attributes, but it would be insanely complex.
> > 
> > For a dmabuf fd, the story is the same as guest_memfd.  Unless private vs. shared
> > is all or nothing, and can never change, then the only entity that can track that
> > info is the owner of the dmabuf.  And even if the private vs. shared attributes
> > are constant, tracking it external to KVM makes sense, because then the provider
> > can simply hardcode %true/%false.  
> 
> For CoCo-VM and Tee-IO, I'm wondering if host or KVM has to maintain
> the private/shared attribute for "assigned MMIO". I'm not naming them
> "host MMIO" cause unlike RAM host never needs to access them, either in
> private manner or shared manner.
> 
> Traditionally, host maps these MMIOs only because KVM needs HVA->HPA
> mapping to find pfn and setup KVM MMU.

This is not actually completely true, the host mapping still ends up
being used by KVM if it happens to trap and emulate a MMIO touching
instruction.

It really shouldn't do this, but there is a whole set of complex
machinery in KVM and qemu to handle this case.

For example if the MSI-X window is not properly aligned then you have
some MMIO that is trapped and must be reflected to real HW.

So the sharable parts of the BAR should still end up being mmaped into
userspace, I think.

Which means we need VFIO to know what they are, and hopefully it is
just static based on the TDISP reports..

Jason

