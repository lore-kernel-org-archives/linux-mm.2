Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01E92C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6B986B00B4; Tue,  4 Aug 2026 09:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B42256B00B9; Tue,  4 Aug 2026 09:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A31396B00D9; Tue,  4 Aug 2026 09:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DFDF6B00B4
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:46:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 00859401AD
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:46:25 +0000 (UTC)
X-FDA: 85063711572.18.7E8E5C6
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id F12E814000C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:46:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qVQZZvjE;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785851184;
	b=foq+jznZJYxCiZ4wz7AaVxfmZAroUY/LgQoHMvTmtXsz46Uf3mTODm0k7fb/d8Q2V+5Ed0
	zHHMufh+1mv62hD2l2rJ+Z6pwdv/grnt4TzEujh8SNR+OZhPar/mp+gsRJKFfcI6Am9QBc
	+x/17kdsutPpRNTm+EerixgCQ+sLrYU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qVQZZvjE;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785851184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=53G6mJGAaV7ofRwgRemJGkr5zkTXgvKFenxfcvtRtyE=;
	b=tBnkbcZmC35V959ERcJXj6TRqrqMQ2eHZll38hFc8av2nI+KKJFKbKfb/EBF5cjm8mdjtr
	ltYY9CkfgjCrQqVK/3aCVI7HHXhj11yQa6xLOTpiR6SAX96btMkne8RsWdfwiW2jDt7+DN
	/2fNhSw9BloeItKTJsp+0J2Vexnfosg=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cb5b8572b70so3849504a12.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 06:46:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785851183; cv=none;
        d=google.com; s=arc-20260327;
        b=KOt7mhxERI5TM8DN4+5kAZZRjCIpthNNtECIG5HizdTovDxWzFJO93sYKqfE1sIY9z
         cxRwc91SilleJGAy96KolTNYE5N+8jXF93wt6/ZwkaT3vNBG7sIIhIw0t6QBmM6xLoGX
         ELlCAS48zBbTUgRbDcgHrC08HRddfEow/8sNC8viJniyEP7e1LiJX+/5JT+CIkM9tLZ8
         tHscNkTPwSXQaykdFugr63WNbnSi7r8NhLYYkc06V47hA11tU8O5KQ8OWP8rETfGcJC7
         /SvUNFXMwB1HAcKmtb/wqJQe0v7OVRo/MRuks00D6nWo9wG1YrP8Zyz53tXwQ1R7WSOG
         T72g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=53G6mJGAaV7ofRwgRemJGkr5zkTXgvKFenxfcvtRtyE=;
        fh=rMOk27D8KDHMz1uf12HJ5ubOQ968vkWcPYKy+pVNik4=;
        b=grZHFFq/QLzy8UaEdER+ELGLMC+Nt/vbc37w8VD54zRcNlsYCZOMtUZ/hhDIzBDwGM
         PDZunPm+nmEKnZl1umXa8iuyHKJEv2lZjRHKavNCaPNqWVtWeaWAtlXvOo+FtYQufCFZ
         nEF6FzMhBirYcBfGN1tYbYTNcPPn68GwasOzgSyZdwfVstK7XumZ3SqHjEos8cjxkRsS
         a26cvdO3YPAnSwLqR5EkwYVGPoN5vFTL1ORwmcIQF8026W74Vjl6pMk08nIDK8Z5PAVG
         DIKXp1cnGcRo/O0MelvZCaQh0+0EXUr9I6/xEu90ncxPaTuxQgczu8VGLkG4ysmokpsQ
         CQ5w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785851183; x=1786455983; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=53G6mJGAaV7ofRwgRemJGkr5zkTXgvKFenxfcvtRtyE=;
        b=qVQZZvjEsho+1IHf3fTX7SFh4gc2aRcImMTh/jvV0ea8FCO2rFqzZEVhj8w3PdHNn7
         a7Do58jGFArlTGvD9jXLk2dFFuYzFlZvQKRZNRDGbH0UfSQR1CTYlufmUifoAmXICoHj
         npUOsT8dCAOPWDlKnZMewAtzOmTxuYXPtcaA3O69sXOGiSnR5V5xkdKTy9L18uv1yfA/
         ZHCFaTOhIXwo5m2afLPIniyLGjeqBj9dXSCxNUeN9NTQa7JThdtmRJIC+n6la2lzMH8U
         tA8sqwiOZKKde1ReJ45/Rs87uZfwY9e268Av9xg0FDB/jiP1WW+3pWOZDp3/DtI/edic
         sdRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785851183; x=1786455983;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=53G6mJGAaV7ofRwgRemJGkr5zkTXgvKFenxfcvtRtyE=;
        b=W4lC8d2ZtVMC/P9s+Am7IBiVIWdABPrHcQuy2MWha97t20asv5iSXiTaBYPA5TIdkp
         kQqoY0gTPx07SvT2nCBVQ5jLJxvwqiNy/C0iTsO8yhDnNIoPViRh0NWjV0C8CQwORK5w
         9NEWwtv41woGySTFIzvaCGBuJOGGuKBEF1GCDgNUU1Ov8Rk4PBu+AYLaR/iBw4BnzCxa
         QzDk2EUAW57tPWN56mQrgX0IgRLG39wLOXuXJbsMwQEoHT3VFISaNnPGsHJ37WBUsDvq
         FD2PP7wq9UdqIqArDPM7qm9zG5ec6luWjxLKem57nOJQcMT+lAk96c115aqhAqOxed1u
         8W6w==
X-Forwarded-Encrypted: i=1; AHgh+RrgK1RJDRBJZbT1ioOHw3BvkK513mH8b97w7NYZW8qa7uRMc1JrE0X4BooMK/OUY9BK42d3WNXrBQ==@kvack.org
X-Gm-Message-State: AOJu0Yx98YpYoc8Ywl6jCpbK7tbLFVtiZ4IpeGQ11McLChN2f20AgsSG
	fRyyk6V8y9xjHo+iclxLXZMPDOkXwujOKemp63Uo2Jv8qKe1d0JCV86XA4rPujyXafNarsFW9LD
	NG3KpnDkOqhr7le66AbPp/RkNxSjLUUN4WuxYjDzJ
X-Gm-Gg: AR+sD13FbHfTK8Sw6kc0Pjxq9ANYdNaag7GM9LsFNLQQwzTwI3ZPsJXuVjfdbmsdm/f
	1U+ekzB+c2toDeqQqa3ikpRIucRkbbijwLojMSYI6quxHOzLMnafauh0+PbguR7L2G6dBfpV31N
	O3/BvHSiU09XU+8jhFlgbLgAFOOc8rfMJLQSqmYEm0AdIxe4+gZUH726YiZpvNE8o5GkZY5CbUN
	jPVBriCgozGSaG+ENte4h+kg47H32fHDKmZQUt57b8x6LEM56+bgTJMxVD/roW29KaE4oxpxCzi
	VECZyOgkze699QmmoWsDkiP0ILGwtEVKW05T4Plw62w6UFSsDgjo8N5HY2Cohad9Vr3YhtdeKMg
	piqCHZi+617I=
X-Received: by 2002:a05:6a21:9f10:b0:3b4:931c:3c7c with SMTP id
 adf61e73a8af0-3c92a7bb452mr15042590637.44.1785851181842; Tue, 04 Aug 2026
 06:46:21 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 4 Aug 2026 06:46:21 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 4 Aug 2026 06:46:20 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <amzIckjuwf0JfINI@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-1-35f9aec2aed2@google.com>
 <b78bfee9-29f3-4044-8ac7-f294b3cd0ad8@intel.com> <amzIckjuwf0JfINI@google.com>
MIME-Version: 1.0
Date: Tue, 4 Aug 2026 06:46:20 -0700
X-Gm-Features: AUfX_mxGk5RmzD5OeFVHjblIz9X-b3hzxwJd1etRfElQwBfbfA_qJlZkICUGG7E
Message-ID: <CAEvNRgGJ4DQuOVafc8ipd8NGP+6y=dcwSZPGOjtrHBAGO7sB9g@mail.gmail.com>
Subject: Re: [PATCH v9 01/41] KVM: guest_memfd: Introduce per-gmem attributes,
 use to guard user mappings
To: Sean Christopherson <seanjc@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F12E814000C
X-Stat-Signature: bce67xtrnro3iizqz5191yacro74n41i
X-Rspam-User: 
X-HE-Tag: 1785851183-615820
X-HE-Meta: U2FsdGVkX1+2lec1x32PfRe81uD5NqxkOc7c02XmZCY12njxCCeYHC+c3Wu4rQJxr9vNmMvBuYjLbwO20MT7W9/5WJ92BhGXLDdHEKy0RwnAg/42jdXH53gheWBmOBOaIFkBlO20q+QOckjFtEBoCvljLiVEBoIwMpwiI9UkviISbyG+DXqrIcPsf6sUBgt1icQsixg2LGSy13wj9gxyQDIbP9j1VWxFR6ahv8JW3/sK03j1vXae5pQc/UD1jD0cGfUfHopJTigHepC+ZFPFvRnUIEK5Ug6gax16sHOYxVxSfELTJGYoQEFvT4+K+q+GLaiMdipkkxdbgUZprpIFOJ3y4/6NIsIIb6iS2qUGcDcid3HoEEXwA85po3uh90nvP6r/ljxLnFaGgnQEcacr8uxnl0oV4p2sMFO92DHPzcauzJWUbH/ZWOiNGq223ez2PHySmWqFlOLoWbtmfJl/bIQGskl+iiMLwSy6aAgqBMK2eyYp3Caipdq3uQFbMIi7mkGLT/y1EwaszxIIcwoVkpUzQ0lGgu/N3ePzd43kPq+3c5xqPBfTdqCtEi3n0STHGOL6tjy+Mshn9SEniZuHby8CgAzhzvHMSD+hwa4VCEZC3pp7zmdrsUdDw8U+1rlFPrGp0xFFBY4J/+XfKA+PklRry+3il/l0IoksxWIO3m3m76/0kRtQ81yKlnQvmuECsfiroqsJrFo4lFS0kvwNJZddF0vk8RUHcBaG8oFco1p0ho6bXDXDA/iL27oxIISfVp0SoAU/Ch7Pa7Ed4pR0ZgJE7LgYM07mRiR/tO/fUJGWf923KutdvIsCt1ZcRbL2RtrdhePIqieyUbzlMuUt4CrHQnkscUkcPj5qHlx+O1g95vdEOowkmfQrIHSPNAlSHjqRfM5VSIVssk/cxjpPkNRudYO6fbmcM5z9C31l0ntgx/EOuWNo8KGQooa8sMXGSL+4LupA1gtka0oTIEE
 Wq60JHaO
 N1dcu+JGV/SMo+XCXP2hFdhcg2tOD9KnVZ79Mhw29Uo1BhzCTlVj5HLSBOuNMMmAmXDfLjuVmlmChx2pM1mIQnVjHrcCY82kuU11/7PkbiGKZ7XOaoRGIMy/rSHCKFZ6dATgxJf35SKxlhbb3w/60p+8W2IyRAFICGNdaULfshV6Aiimmsy+0l5uksrdjgopcrq1O0yt18qx6OmHF5DzmTnShGJqXr2qhbeJ56Hd/nkB//DZ8f5PSFu22i4sVle4TCyzY/OazAcidRIv6SJVrlxMX2KU6xivC2XmIFj2MpMdOgzfxRFGH7C/ddykKDMDEt5+7J/wkD5lqFUgasiWhygAKGxBxol1PBrH9z5R+hxmqN5ZrMkkf4o99czK3Z1ZkL33fK0XnHIcguZRDGNxNHIw4RFAoj09kIn7E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Jul 31, 2026, Xiaoyao Li wrote:
>> On 7/29/2026 8:35 AM, Ackerley Tng via B4 Relay wrote:
>> > From: Sean Christopherson<seanjc@google.com>
>> >
>> > Start plumbing in guest_memfd support for in-place private<=>shared
>> > conversions by tracking attributes via a maple tree.  KVM currently tracks
>> > private vs. shared attributes on a per-VM basis, which made sense when a
>> > guest_memfd_only_ supported private memory, but tracking per-VM simply
>> > can't work for in-place conversions as the shared/private status of a given
>> > page needs to be per-gmem_inode, not per-VM.
>> >
>> > Use the filemap invalidation lock to protect the maple tree, as taking the
>> > lock for read when faulting in memory (for userspace or the guest) isn't
>> > expected to result in meaningful contention, and using a separate lock
>> > would add significant complexity (avoiding deadlock is quite difficult).
>> >
>> > Co-developed-by: Vishal Annapurve<vannapurve@google.com>
>> > Signed-off-by: Vishal Annapurve<vannapurve@google.com>
>> > Co-developed-by: Fuad Tabba<tabba@google.com>
>> > Signed-off-by: Fuad Tabba<tabba@google.com>
>> > Signed-off-by: Sean Christopherson<seanjc@google.com>
>> > Tested-by: Shivank Garg<shivankg@amd.com>
>> > Co-developed-by: Ackerley Tng<ackerleytng@google.com>
>> > Signed-off-by: Ackerley Tng<ackerleytng@google.com>
>>
>> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>
>> <...>
>>
>> >   static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
>> > @@ -60,9 +68,25 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>> >   	return gfn - slot->base_gfn + slot->gmem.pgoff;
>> >   }
>> > +static u64 kvm_gmem_interpret_entry(struct inode *inode, void *entry)
>>
>> Ummm, I'm not sure on the name. It doesn't look like KVM's style?
>>
>> Maybe, just kvm_gmem_get_attributes()?
>
> +1000, "interpret_entry" is extremely vague.

Was a little stuck with naming, my frame of mind was that "entry" is the
attributes, so I can't get attributes from attributes. After you pointed
this out, getting attributes out of an entry makes sense.

Will rename to kvm_gmem_get_attributes().

