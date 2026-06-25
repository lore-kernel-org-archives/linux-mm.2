Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB4A1CDE005
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 00:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFD6D6B008A; Wed, 24 Jun 2026 20:19:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AADE86B0092; Wed, 24 Jun 2026 20:19:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976C26B0093; Wed, 24 Jun 2026 20:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 721336B008A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:19:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EBF571A04EE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:19:52 +0000 (UTC)
X-FDA: 84916527024.03.8D6FF41
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id F2B6B40009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:19:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lGyEBDXJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782346791;
	b=eJFrb1aInPZuYqJD6tT2xyKRgvRr2mJCFOUjBDT2ghADK269+9hCW6+IVjYjex5zRWPcH7
	Y5NHTeW6WN7tocmGTF9DynUBau4KoXrfgbMtAYimYxglw3NIhCXyLV7T9f3NfYzJL9uH9J
	obl6Qbwf5h4sG3FrFpAoloW0DetNjrI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782346791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CdGA3bllvZfq9+oq5ATtnUq0c6NavELb8bI7ZCuFA30=;
	b=kanWYipjHZwlLTYEksiuYaGAwlhB3jMkYV9pU030ysPP60FEdPHWlmIhoEBKjcE6u01l+3
	3TqYEdrvzqhM2Y5XOm5tY98/JMtQeiLOuwtURQ/RRtsv+WInF72hvrBeGmjZNTtf6S43A0
	iZuKrb/INIbGaTBqgwgLULZDzAEE5nw=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lGyEBDXJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-139b914bab6so1871114c88.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:19:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782346790; cv=none;
        d=google.com; s=arc-20260327;
        b=Wk4NdLU9ocNrJ0vS/pXITjs/GlLsu4qj8N5MQQQFkcCNIcfO3VA2pcrV6zb+PLA2ZV
         QB/T4L4Q9SqReN96ixksWiMbGITlhotKdjdocxgfnzq3LPmwA1zqgP1n34BoKYJmYmmL
         QrZAC6aWhljJjbK/tgAN2AgYarNejrBbseC/DS0YaPO6a8laSrXNVjJSUURGWWB2Rg6d
         43CVPIVBbH13ou+vUEFP4BKBaB5Us8amEN6zNckLIt7TMIQpFrRcRz2E66CqII2ToNQL
         fTMPn9B9zjyTSVh/stNUK/m0jqSIleYk80bROeueItJZEaoKorWNuTeUYnZ4/N2jsd9o
         KZww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=CdGA3bllvZfq9+oq5ATtnUq0c6NavELb8bI7ZCuFA30=;
        fh=lteh8uy3OKLESH7a3uFZLZycbFgpB/YkfdkekhRkmc8=;
        b=X0ZNmpY5cp7pQ/J4FIHz87Mx77DHdXqyn2rAbU3xIGS5hk1StSOwGhe/vdE59oimec
         byVrNDKhxWDVeSPUnbpKmsSsCQ0BA//QF8XXTRhw+alRB6wyiEInI9iP+e6fYxK5Ty6p
         pzbzsP2tiSckxfPrnoOQc1A/mpgKcyWNTOPDTSaa1mfyfNlsCFwVOxzGBzqxq2/QAXMD
         y5QwDforv1WmDMR1DR7pGFqtSTOjGD5BkEz5LQ/jsSnUjAEO6xghVx/ssCr8FYMZNmWC
         MbFOXdJ269WG3pHtpBbpfd3scIoTFsl7lkbZomOY5b7W6KM8I4pBTXMfZz4mSfI+JrZ0
         Fh5A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782346790; x=1782951590; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=CdGA3bllvZfq9+oq5ATtnUq0c6NavELb8bI7ZCuFA30=;
        b=lGyEBDXJaGd97olJETeELtB8pDf9i95mENtCppibFq/Ah1/jCPsQlMsIaqn+6gzOw1
         qgcq5W1lop4lnY8rNHHuLBZHMCIqcuG5ZMC0y4fyezc4lT12zWWBX4uyvDug46sq1LWV
         djs7qLyX321Ggyxq0i5KinGdqtoUiZ+KT2PLJK8fHPnPiYmNZUP6bDNNVn1y7op/RqaE
         2LZcSNiyb44z2CWLp/wv+kJlGHm816In5XZykfVrVKY9qu1j+KT6IxzexCrBkcoOCobM
         /xNDTxsiEr2HmPJjj6suBH4w/FKg9fr06NL5E6Pd8akOlXSuYsHyVmUlNvq3u6bXR+Gm
         ntcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782346790; x=1782951590;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CdGA3bllvZfq9+oq5ATtnUq0c6NavELb8bI7ZCuFA30=;
        b=TcBuCkp7D3aijI+ElZD3QdwUblmlgTRzRNjNKC0Off5CwBM8KAnEAv3c9Je4Y8I4dk
         PZgZsnnTAtqu2eFP3aO/OfwT22WN8SLiktRP5QlQGvzkmJiPMaBuk6PzxCf72sWCbIox
         5DBfiUxvUbVQzc20Y5E2l3vukoeeK6skUjao/ajzE9E6CqL9kbSKn67hAWhVFuudRCAm
         kaQuMgynTGbjvtu8jmE1ES3n2Zwz5r86C5T/s43S1JbSwWMz37z7cMmmST5bCqZ1MoFF
         ZznOv2kgCrquo12U5RHee/hnT/vXipt559VHqtWb3gHH+NAlw9zKjtjeBCfxCZEU2G1A
         SPng==
X-Forwarded-Encrypted: i=1; AFNElJ+EGF9tZw1UdV99P3gUC6PWbEXNFveXsyQuT50CDFdMEau5rE5kpiEEK0s8Lp3CPyLEPLs/+xrlrg==@kvack.org
X-Gm-Message-State: AOJu0YwIeE/Tok8o1AXm4BCd22xH2Fb68Ij9i4XmnQbg2sQ8vtSyC7/a
	leZxTk400jIvICVhGFtLtMSQBBc0t3OYtycWTRP03rj/ennSNRp4bkUAWqE4IBF2V4iqU+hglU0
	0veVIy5riKHN8xgjQmVWfiFYzxNYQTvIwsKKN534q
X-Gm-Gg: AfdE7cney+/Ad23/0LZDt1pK0WaKCGuL8EOYOW/aMXoVAqioaLK7KUi8ATUuohL3pH0
	17lU4OMT5aQqlnILJu3ObEXZAKeKQV1xtfjR+MOjNCa2DMblFVTD5PrNXer9A0KxcdeNZljdooC
	fINEohIXevxJwJprOm/GnGglG6kv6C60utdgYRVWeW+u5ymTHoA3Wma/cDR8qGGyMAphMjhtU1a
	3Cno1mzOSdD9pG7OJPTLatVLYfD6zZItgUk+kR/stZ7tevxXO21JT2ZjiiPFdUP/vQ06SPbzJV4
	+O3oPYVG7rhFM2BnOtdSEssmVotBZEpcUbFBeUaJaHbnMpn6S6qEz0AX88Q=
X-Received: by 2002:a05:7022:611:b0:137:f001:fce2 with SMTP id
 a92af1059eb24-139dbbc564bmr255822c88.33.1782346789006; Wed, 24 Jun 2026
 17:19:49 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 17:19:48 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 17:19:48 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <9f81ea12-98c4-4ce6-a95e-233851dfe8dd@intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <9f81ea12-98c4-4ce6-a95e-233851dfe8dd@intel.com>
MIME-Version: 1.0
Date: Wed, 24 Jun 2026 17:19:48 -0700
X-Gm-Features: AVVi8CeR8FAzeQAvNnM15yag_GxBRrpO8H44tlQVk9R637S1b27Bxjsp2TDXvkw
Message-ID: <CAEvNRgHR-6X72fvx-4s+RrsMHohSCBu53bVX4G3x-=XGLnOxiw@mail.gmail.com>
Subject: Re: [PATCH v8 00/46] guest_memfd: In-place conversion support
To: Xiaoyao Li <xiaoyao.li@intel.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F2B6B40009
X-Rspam-User: 
X-Stat-Signature: 9ttgf3h84ut4ua7mecxpanxsdik8u7o5
X-HE-Tag: 1782346790-790295
X-HE-Meta: U2FsdGVkX1/BFyhakGf9nG88gMCTjkosWMBxyWuy/9LREE1+HDFQQ5lZLUId2t2XxMHz4eI4Yj4ruSBmhosRiufCnxyak4b8ra+rDyfVbXPIbIMlfS2nMrhdTwN2jSbycoZ6CmLA/EuobTGTmfnMVvuf8pZRL06h1oDWmFg7jC4Fq+KoH9Hh2GU7M//Dn6CXLzNhCtE5Z8dHp5tHpuIhV0onKInyoJ/NySRHz/uv6IF5dLXo+82x82xK4ShyUqDbIehrVkI9mneUa+hdqGMclf7DMHNido9cMfkWsqNwInyb2li1eiYi0zHSTT4eBMK0tVcRPeRSDnvzbYvRzjy1YAZMjVuhxRnD+JMcq9TI1XQ7CIBJaf5G4L3HQ5ScWVmX4oiE4l+Up3qZmt1VdNi0WzSy6t8tsJvXPuWOuo5AX+D6m7daiEKoHD4sBRpVZNjsknBKe0NgykMt9YlDhy5paKEooOxh0m+NxBi7ATAjXPfmU5Eqg4g7TcgNwft3G1stAziVUvTxvHC3GE3uRR/o/spWKSrpf4Pcx0Cqz89p/uCW1hi3TkPndkRH/ZyH5gdefrYgN/+HL/anp4XbNR1Qx33eIOBY1pOScFhfzNIuZzZ2upWq455dYaSlDIWVXWi9dVC7DXZnrIkS9SzqLa2o9lL45VuEPTrxl1RCnvI9zvoJATVJCzfgVSCsh1ri4D+VJZq64aH4HDhlmjvrn1DM+xeptqZnDo1+Tuu6gwfYPAC/F7drLbD7u6Q3nHpAClaisjBB9xunLFxzJ1wQuoccHQhqbKuMD1wk+Zk8fByl8VQdAfTt4QlT4DVGBxGL0yELfUmFYH1feVs9bwW71N7T8b4mQ7XYS6d1ldygwK6b9zuf2To/hi8qbF0F6X6agYn4SHPqYrJoxWEuvL68rGW7oIZR0EEWAz7vy6gQXfC6+YgAC840fZbEEcsLFIxq4OOoMIC8XXuBIOLCm5i2Pjj
 JFI83i2O
 c0AEE2nveJE59usc2VHjH1rPINHi//oYfWVu9JYWvGExGxbl/ocbMh8L4m0SqTt+f6vElG237vEixNymTzaK1r3JzgHLQAWW63nZsKJbCMbCcgnnCk17GHAPnjXBVCggc6LpDuKrhj0kEH5QdgCcvg2N8zG543ymHznCK2sqfEHY+mctB0gib0ULK2UvO51bCMpdhpeq51ylVWRiynEPm57PwZsHJccqx71gJqGrwyuCnzA8AtO/YPQZNUqEK65PRTyPz7XOqdps8rQtwJzXJNlOENIoFdgq2FmZtHEo4MigDS3eglK+DU45XStqMxsULlugXsVqMYo4am9exD2fTanAKwFmyeW0Gm04bo94wCFfYW5vSYDfecrd4jYWn5bIq/Pr9321c2mdbkOYD5PXBqkZnLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
>> TODOs
>>
>> + Retest with TDX selftests. v7 was tested with TDX [12], but the setup there was
>>    wrong. Conversions were successful (no errors), but the shared memory being
>>    tested is actually in a completely different host physical page.
>
> Glad to see you knew it already (I was going to report this to the
> original POC TDX patch)

Thanks for reviewing!

