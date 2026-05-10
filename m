Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D810ECD37B6
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 13:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 087466B0088; Sun, 10 May 2026 09:43:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037266B008A; Sun, 10 May 2026 09:43:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E67FC6B008C; Sun, 10 May 2026 09:43:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D426E6B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 09:43:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 747FE160398
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:43:58 +0000 (UTC)
X-FDA: 84751628556.13.4770142
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2CAFD1C0005
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:43:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="DbqDM/Y2";
	spf=none (imf21.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778420636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qOD7QxDKk3RTKnTDgKCKX5Mj4tjif9QPuV1x23Y+qME=;
	b=hNUq5gezQbCq4r4uRgbyPz5av9Qy/IsTJp+//XrhT2rYdA/FwslLeUWhQ93ziJWnRzZYt8
	tBHKS0FyFGDGCPocU2c1jb96d0YKbgRnn2k3F+iRE59oqcZNMezxN4W1HQ1RG2WkhOADBG
	qSx80LCGqSiVe7z1MFDIPPAfD59Rovc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="DbqDM/Y2";
	spf=none (imf21.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778420636; a=rsa-sha256;
	cv=none;
	b=Y2CB0Y4LFp5JHQo8SaR9+ezOfEttxlnnLTXdYoXyXgBICcZkUwsXJ5saT2REoXlJYBzp5+
	bxfp+wlck5ZLy/DMqi6fvuSIrueqYttUbU690geiAA295kp4smuKhfYCwQFRDs1ELr/km3
	6Fs2CvLZXuCdeQd3Rl5lA6ApbEOIlH0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:
	From:Date:Sender:Reply-To:Content-ID:Content-Description;
	bh=qOD7QxDKk3RTKnTDgKCKX5Mj4tjif9QPuV1x23Y+qME=; b=DbqDM/Y2NO6hs4kz0Y3MeDoyBa
	RSWqPDNFSCwDZPKmBnCM0Sk0LtTSOYvtX1pGE7pAqKTzP/+bhJ1ZbzOORXjS5TN1tEZQIISZ/G/uv
	VTpiTcl4OvDMUgSnKV892USVGtpTpoLUuURW82/UyphNjFe7lMvTDRDZnj7h9WgD7knqnFC+Zyz4+
	rF4k/UaGF9Uc2rQ4oYFGcBNsUpOZkl9egs5sj/UMoiy2SiMJ2afO1t2v+mc9V4mj4bO6I47trVbES
	R9hzfaaYRipyM9f09YTVGrLCMy/2oVBxbjmupoL49saso54NbueZks0urkiVkkSBw3xZAGJZcVCcH
	1uryzAGA==;
Received: from [38.23.173.23] (helo=ehlo.thunderbird.net)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wM4RG-0000000AryI-1hB3;
	Sun, 10 May 2026 13:43:22 +0000
Date: Sun, 10 May 2026 09:43:49 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Ackerley Tng <ackerleytng@google.com>
CC: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com,
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org,
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_RFC_v5_10/53=5D_KVM=3A_guest=5Fmemfd=3A_Ad?=
 =?US-ASCII?Q?d_basic_support_for_KVM=5FSET=5FMEMORY=5FATTRIBUTES2?=
User-Agent: K-9 Mail for Android
In-Reply-To: <CAEvNRgF9+Gr7UVEq-E2SQEb_XOQQMOXy9F_A2tA=DbNV_fJ0EQ@mail.gmail.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com> <20260428-gmem-inplace-conversion-v5-10-d8608ccfca22@google.com> <n5ce32wumzeiqqyqutom4apy2kqfetbvusc6j4k2xarsska5mw@klp5bmy7qhfm> <CAEvNRgF9+Gr7UVEq-E2SQEb_XOQQMOXy9F_A2tA=DbNV_fJ0EQ@mail.gmail.com>
Message-ID: <1DAB05E2-7F30-45D7-B155-B66C59D31AFF@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qizb9h5uktfnyi9x7dyjmjtonoatjnwj
X-Rspamd-Queue-Id: 2CAFD1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778420635-407469
X-HE-Meta: U2FsdGVkX18NQLiT+WIriYgCBxkEUUZq0pdptCWyitdcM7kkOGQwkUGqANtnpWVrRYdKDwWsK/3Af3IfJvK0PJ0FiYkQzla5LHzukOb33VdD7Wv7AMAk6Qd5YpJMcVPtIrmYChUuOy/7JhkhTjY3fJPareY2RGGOEAWDRQQDsOKmeNaIfslTJh4ikdaTC6Xw9HhJDA9N1cWwk7stNIxTeND6Y9olkK+SF6H/k4AoI8vsgNM9WPE4gIwwlypp27V6uO0HODqCxzQx/Zo0NDpJs+epA9gZt4UyzEgrezlZgazPuRFlrJqH/LgVgy3Qs1szOci+NFyxx7+svDSVBsOG3XvOe96c1vag7VkcPS6DLfJxY7r6ahoVbK+SHrYcQpNPCCw+wQecUHSXC9+Yw4rm3KPOwXzI6JZkdoFrCVqA0Fgqy/r/iURY2HttDljFsd4M6g1chmGBY5TAJomk1fbp6ZyHjlruSBYODYnA++fLEjRpA/gTzF3wNDjD0dTxoQ36ReU851n2axoKdAT0jiZoykCMd6oHX++Iw7v06qergNhTp4b4eAjfMH/wbaSPKCLOhABgBlKr3xMy5w5B/MW9y9GnzwJjMXlaPjFdCJlxehriolgwjZBu7qHgsIHxhB4BDv4DqrQwsODqW0ySqOjQGc2xPCaK4m3yFxDmibj7WaX5cX1U/wGi4LUvKpgvzlCYuKvSvcKzKEG0iIp7IiY2jixR6wHBS0CSdwRaMArP30NY7o37tiKdTlrQG/Thh9olODBcyiUmIyUE57eDtfgZ00mVHOw44KPcHcz3KX8ihQiYP5EzDKneLgy0FLzQPpBzysHXp1ES/JSdL1SGxCtuZBORxmE6+a5fGINnhWM3XqLnrf1VOSekn2UXyx14xfCXHkcK1AVLbyLvFw2D6yAt02Yc4wa9WiL2Os4+Wh1vjoOaC7n6mL6SJyUTvhaqY/gTwpTzveWrFp1vvkgA7ff
 MyHdXUr7
 3aav5YTAmlIvz3VogkZoUkRkpkz+XlBCjspCOF3NhtmGmU9Jp6CFcW+YQ6qzGjJzHmRbUCaPkERWUIgo/27EEkvFf0gEMv+wT2PUqaL7ZFiE4IHWLAZ7EAhUeIaEL29B6unAERxkpp7vubB/vcx77qhouRBN28syul/u0Lav1IdjTywmeYqqjRYPSycQQAVBHeIdWM6kVIuLEBloT6eu355IAIk2skJWartqElNLF3ha4Fr34wuq79XNugr73oLyVu/xIn4l1qcMt95oU1NP/+vD7I+kwTzT71zp7vUu4QCbwGMjqIh3WTA7t2FPD4p7hzMJAm2zgGgYg597ThiByNUDrnbTt+JDKpcBI3gqUFa7VCZF1NgGFdGEB3Ckdo/X188h+XfcftoRO9NkoVBAwrCbdeycrnr7l92UOXNNci2aGZws+1s8P/UuOsh05IP6lIb6G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 May 2026 12:56:11 GMT-04:00, Ackerley Tng <ackerleytng@google=2Ecom> w=
rote:
>"Liam R=2E Howlett" <liam@infradead=2Eorg> writes:
>
>> On 26/04/28 04:25PM, Ackerley Tng via B4 Relay wrote:
>>>
>>> [=2E=2E=2Esnip=2E=2E=2E]
>>>
>>> +/*
>>> + * Preallocate memory for attributes to be stored on a maple tree, po=
inted to
>>> + * by mas=2E  Adjacent ranges with attributes identical to the new at=
tributes
>>> + * will be merged=2E  Also sets mas's bounds up for storing attribute=
s=2E
>>> + *
>>> + * This maintains the invariant that ranges with the same attributes =
will
>>> + * always be merged=2E
>>> + */
>>> +static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attribu=
tes,
>>> +				    pgoff_t start, size_t nr_pages)
>>> +{
>>> +	pgoff_t end =3D start + nr_pages;
>>> +	pgoff_t last =3D end - 1;
>>> +	void *entry;
>>> +
>>> +	/* Try extending range=2E entry is NULL on overflow/wrap-around=2E *=
/
>>> +	mas_set_range(mas, end, end);
>>> +	entry =3D mas_find(mas, end);
>
>Thank you for your reviews!
>
>>
>> Please read the documentation as I believe you have a bug here=2E  What
>> happens if there is another range stored higher than end + 1?
>>
>
>The invariant in this maple tree is that contiguous ranges with the same
>attribute are stored as a single range=2E
>
>The goal of this first part is to get the entry at the index just after
>the requested range, and see what the attribute there is=2E If that
>attribute is what we're about to set, extend the requested range for
>storing to the end of that range=2E
>
>If there is another range higher than end + 1, with the invariant
>maintained, that attribute has to be different than the attribute stored
>at end=2E Hence, we only want to extend this requested range up till end=
=2E
>

mas_find() will look for an entry at the given address for the first searc=
h, and if it is not found it will continue to search upwards=2E  Since you =
limit the search to end, it will work as you want and there isn't a bug as =
I was thinking in my sleep deprived state=2E

Since you are searching for exactly one address (end), it might serve you =
better to walk there=2E  Maybe walking is a better API for what you are doi=
ng here?


>> Do you have testing of these functions somewhere?
>>
>
>GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4) tests setting
>attributes in ranges=2E If test_page is 2,
>
>1=2E [0, 4) starts off shared (4 is the number of pages in the guest_memf=
d)
>2=2E [2, 3) is converted to private
>    =3D> so the ranges should now be [0, 2), [2, 3), [3, 4)
>3=2E [2, 3) is converted back to shared
>    =3D> so the ranges should now be [0, 4)
>
>I verified this by inserting some trace_printk()s and inspecting manually=
=2E
>

Thanks=2E  I find the exclusive ranges a bit odd to think about in the map=
le tree context, but this test case makes sense=2E  This is especially odd =
to look at a single index entry, at least for me=2E

I generally have a set of test cases and append any bug reproduces to that=
 list so they are unlikely to reoccur=2E  My testing is certainly different=
 from what you'll be doing, but this method has done well with the quality =
of code improving over time, and limited (if any) regressions=2E

I actually insist that any fix has a test before I accept them=2E  There a=
re two reasons for this: 1=2E Avoiding the regression=2E 2=2E People really=
 understand the bug if they can create a reproducer=2E

I hope this helps=2E


>>> +	if (entry && xa_to_value(entry) =3D=3D attributes)
>>> +		last =3D mas->last;
>>> +
>>> +	if (start > 0) {
>>> +		mas_set_range(mas, start - 1, start - 1);
>>> +		entry =3D mas_find(mas, start - 1);
>>> +		if (entry && xa_to_value(entry) =3D=3D attributes)
>>> +			start =3D mas->index;
>>> +	}
>>> +
>>> +	mas_set_range(mas, start, last);
>>> +	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
>>> +}
>>> +
>>>
>>> [=2E=2E=2Esnip=2E=2E=2E]
>>>


