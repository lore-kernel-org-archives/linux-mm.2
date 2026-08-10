Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E7A2C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 19:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6865F6B007B; Mon, 10 Aug 2026 15:11:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 636886B008A; Mon, 10 Aug 2026 15:11:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FE776B0093; Mon, 10 Aug 2026 15:11:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17C516B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:11:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C2EE1C0B22
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 19:11:54 +0000 (UTC)
X-FDA: 85086304548.06.59BD66F
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id 98FC340005
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 19:11:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EmqnMg08;
	spf=pass (imf01.hostedemail.com: domain of ackerleytng@google.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786389112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTbNU28ri9zZ2toTUiO4PyOFIf9m/AozcuO/ntOhi+U=;
	b=KwPx87qLW1UoEmXW9viWFnU7s5qE8PMispUjEU0Tfe7tgYi84+W2oBuktszl7a8Jv6xBC1
	bb+klcZ2m5+X1wPVBlooA/FTPELyAjt9X8c0qSDiS8uLYPBRFMWXYjT7HDZfu8TpXCOlJm
	q6gTXLrfslE/6nmyJELQxCc9BWY6Lms=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786389112;
	b=y11BWT2K39mSH+2stMFxaiOUEq6IrcgBGrsa7XXJ/D+RfmUIt91BxsHNVYOIhiWeGYW75s
	4VEq/hk1+yfPOx4Lwx6/zorrkMyjMcKXzZAHg6EAYbjuapklYKdZTd1zTiB3fhZEVubw21
	B9RZjKPrGGhp7Fo4U10QrpyXMs2sKEU=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EmqnMg08;
	spf=pass (imf01.hostedemail.com: domain of ackerleytng@google.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c15ba3a2b4bso135166b.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:11:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786389111; cv=none;
        d=google.com; s=arc-20260327;
        b=i5l72yIbsRLu2Yi1JsfNYm5CeUpb6Q2usXOT/8FlFMnpnEdpByl5Y+H2JnDiI0EbTD
         AiglV9aH/vamQFGyHIMbsnoZDqD9uyoVlNQEd9aGlkGZByAyVe6tZ9E3ZFJOboc1mTbN
         GktnS9Ly6c/oU5AW+uVcRxgmbyVLjhhH/wEHul1rUtqYrwEFz5YfLLUKUplWfWaf5Gmn
         RXjRD0MHd36eS752ZdDftjVOBMlWvuiHCpKuu4FsdBDZ/7CSSkmja+xWTM4TBN2ralkI
         OMnsQJBv/77PXFOmCH3ejaI5Unsthc3Tkx8ag7zIMpn+l03YK7YOi61e0DC5wRe0wF4n
         jVyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=lTbNU28ri9zZ2toTUiO4PyOFIf9m/AozcuO/ntOhi+U=;
        fh=5yf83O/KRTl5fCxeMl4ea2cKRdids2/c0oRGeNwZrWU=;
        b=IBnz8cXOlQeu9WAK52GCNtYkbjYPmOMe3CrsI8433+2jYpJNV6DJXboEXOGr0Aa1AS
         JnIM4Bmsdm/q793UKslT5N7bJZ2ZI2/2ZLXOaMXx6+HqHe9QDw4cvs68K0p0ik2QhuRm
         pb2RSlOC+sAvbTBflXZQM6EaMqhhg5pC7hSxFv78O79TtYDylMUlRZqXBfKQfwGoL6N/
         JWQzwElQvUxhjbruiONMTMTq7Xmfv/prIsSzswAphsXXyamXuPSUbYN//IbskWZvgnln
         YSeKLqzL2g16ePeL0hc+yRqRQgf+UESvFZax4CtFA/HLqguoZykUkGY3rcFa2SqTZGT4
         fnPQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786389111; x=1786993911; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lTbNU28ri9zZ2toTUiO4PyOFIf9m/AozcuO/ntOhi+U=;
        b=EmqnMg08jqB6RRemUqxXoCMlATltR9d2F43XBBznWspwLoluzlpzO6peItemi59V6V
         e66xvtKil1mIlEX2ZWe+W6PrKzBfBlGfxz8AxcfrEfHS7EGptkrAKOcDgqZ+qFy0mCc0
         9tVr0Zoue8XvOBMdjARFbGk52MdFnl9Ld9eLEiwRqn0hC2r8hCcUFa0IHmDy8DpzwAA7
         2SrEIFnR/3xflFl8HvboJF4SIt5bZ5I4t/o4qTZAwuX2p8EqrlHCR2MZ3WY4gRPITEcS
         wH2cGSpoCY+uuLVmrADjhE9YEDrZ2jqEFCcQPu47/FOZ2njve04JEHeAggD2s3BZ5IL9
         4nbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786389111; x=1786993911;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lTbNU28ri9zZ2toTUiO4PyOFIf9m/AozcuO/ntOhi+U=;
        b=UxnkfHRWzgpuYliwnqv7AZOEt5j/DvBSg6FdrepQWyAsZhSIwXmA7X8ynLwg/31MwE
         b9zwldmkJOOx1Bbm0ApjLYCY/hFWkWuaFEEnbM3u0pwNmM4QwbH8rkRQEp8iBOYujGkc
         mOwubBjxzGVUvV4b/N0AzwTZOQRwHLUzCG0eC9O+q+sLUvdf5Qx+pX7Nnlb0qSxjbA2Y
         wsWpms7y8b9U2zjfpnMzRcLbPNai9ueI4cP/5cj22vwBYb0XCepVwwuLVpSeiMtny7bp
         EHQsQiRdoKaTvLBKtSmtH64ek9OHauMzFHhCsJ+cFnwHBS3lxprwfeVHln8RadX/e6z+
         XXFA==
X-Forwarded-Encrypted: i=1; AHgh+RpJ6b8hXx8V+LHlORtHOmqUySFXBiOtxEuWXk0psEj4hiZJN+O5g9xQ6sDiLZcHW8uDvgY4gU42uQ==@kvack.org
X-Gm-Message-State: AOJu0Yw10mOnvw4OTJMgHSJAjGNvPnFxRshzI+HVMO2Me5t+BjEDg03K
	YmBqd2+c7c+o1Csg0eO03WTw7OryGeYj4d/Vjge5Kr2zEM9A53/S41wlz+OFDmvM8YVku1QD9n1
	UjlsbcJkcGdxHSgdlWsiKo6c0Pb3EuVaU7RheNaRX
X-Gm-Gg: AR+sD13HG4UJTh3P0ttCrAI7mbmq9ByAHW4jbVwNHvfxmFmL0/mUCmIXVlDRqQ0wqhH
	Va2yw1aFovwx+KIq0ue7IbxTimp8ILI48iCV11xfsWgOMye4JfUjauB3SNiiWguyDmW+UZXXOXU
	YjZFYe2vFCiyR3jGYIR8Ei5eAtyElIH0tdqOQJJ7C37jWDT+2rgLQtoSET0abyXEi4wUHGKwB9U
	leNWr3Nv4tBtx5LguQzQiTYV3gaXCFpRCaNu7PukGOENOEnNzsnCW1b7dUAkOX4pSJ6JekIN1j0
	l/X9U2oUF02RiF7jB/hmJS1XAEXA54GGN5nVQeJYzY384/6Wo6t5bhI3MYn1HvlM+U1cy/9VZ8l
	2/QiqsYf5l5BpcTyvEoEu5WW4AcYftOoZ8V0=
X-Received: by 2002:a17:907:1ca7:b0:c1c:4adc:31a9 with SMTP id
 a640c23a62f3a-c2039e3fe56mr2131203166b.28.1786389110165; Mon, 10 Aug 2026
 12:11:50 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 Aug 2026 12:11:47 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 Aug 2026 12:11:46 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <cbf5f7ca-a960-4fb8-a760-2d2794eb6864@arm.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-9-2fc18ee6d3ba@google.com>
 <13ca60c6-e154-4397-8092-09f861e90fe0@kernel.org> <cbf5f7ca-a960-4fb8-a760-2d2794eb6864@arm.com>
MIME-Version: 1.0
Date: Mon, 10 Aug 2026 12:11:46 -0700
X-Gm-Features: AUfX_myM87U3S8SmK_og8xg6GGyI1_yRBB52uSNeH53JSCFRKhcscCat1IpW7LQ
Message-ID: <CAEvNRgGOyQHnF_b8dk8E0d7_=CcwXtYUdU3ko7Qbep+_O7UC0Q@mail.gmail.com>
Subject: Re: [PATCH v10 09/41] KVM: guest_memfd: Filter both shared and
 private when invalidating
To: Suzuki K Poulose <suzuki.poulose@arm.com>, "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: seei4xsfcwcyanywb9y5puwusb6kjro1
X-Rspamd-Queue-Id: 98FC340005
X-HE-Tag: 1786389112-980342
X-HE-Meta: U2FsdGVkX188fn4t3wqkaoFHGdW5x6tn+2uJZ1tRPZyaxKYFGT6iY3FSzqXASTa+eVMYXZwNH88NLaFGuXb/YIntGOOw+Jy/P10E46LrNFjx+ABV/FXmGw0xQ7VIA3mjwPqz6oBLqPbEGI24NjftZQWOZGu/je616xc5HJ7pi0ZTw9l2FLfCrLhouPzy4A4QY98VBQi6XYgD9RTfZNOlkAp2GqBnebH2XAUlbmJ9rlwDgiWoC39x2O4mhJ/frawGFDROyFnHBsJUrDt76SfeQUh2NLMNRipiudINEHN/fyl/4dApBkXTK+8nYIpWyoSSkwJcI76xVe+sA3x8L8d765qvrY2LQEspEM5S39/lyfBZxjt1t353YsaJzso09GrBlbRv+tZ4uD//5DcMHvsa2MxdZieYCbqpfT8etLa0tnYrJrKdyJdOlnlRsgwWUfnAsfPad6e/o+DZCKhzCmqAdpjQmVYY7+gEuCasMncM2qquCOCkq5ISGH2Iem9lpRrU9u7x8M3da+0br573up35KCwf4tGbtCJ39sq/oTXw3XoNRwzU6px8jecb+sch+QI1ThEMwjHSDwFdrwEwUnXQeIhPIxWLJ5odOWntmtc54C/RSgw6OR/48bzZ9tDcCgT6LxvDOI/JKIqPH8WgyuykcWZUBkf53Gl5wjGYFiorKPZ8isA3L7IsFaX9FLvRa/PBYQhe8y0GdS6583TutslMmeJHQf38qa2NN2uNkS5yEo/jfSg6Fva3fxXPxQX0OK3FJ8L13FPVVIuLurIgHb7lk81lsTFMl0K9n88dZl04/ofYz9cq9noEJN9WFN56rp9MAEY/hIjyR8u5nZgEgYVecvj13KNze7kuqxAzjovKcFg/kPIcXoLxZNBvsSFHrvykSz3AVuKFQyYi/yPBChzO0A9Zh59NhTQuARLMFbwZjMQAHmX9Qrv1k40hBfwkYy5hUDWw7X1TXiI8Lg3qQuC
 kKrTEIEH
 pigMswqRQm/iDPVFBV/ViAMXtl51nOCkVtthU4asd6HkbcHPi7jZAHJF+C0afUSS2e9AgBz44OoFrz0pXlwYKTmlUndlh6U5Q3lxlOzW0V0IYDkN6Gvi+kioUtDf9qLC7pfBSpxSJ+IOcJUd7dsgvVIxwl+A0rviPx7P9yu5OLajtoRgSK8blfx3xbH6+zlgkiUaQ/5L1boN7gCP8sW+HyXbPD6oCGQJIt0eqoLDBFDUdWSiD/23SwpDwZNK+X0whdZa/cAcZMKqIbUCTT8QE5mREjEhKdCzgF09g/YVHnjaAldMY8jm1zpj3TG5SKL0qlv8xD1yy/r2X558JGDfE+NhaBv6xIGNBAPhAyhivDo+ajTO4ENNF5XquyWvwt8XgOpVGl9QSUhNjNvuJsS81HN85W4Eq4BlthPtJ1FYRocWGcIZbuCS3KLwzHVgrMhuGihTjuj8JaK+AQBQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

> On 10/08/2026 10:06, David Hildenbrand (Arm) wrote:
>> On 8/7/26 23:52, Ackerley Tng via B4 Relay wrote:
>>> From: Ackerley Tng <ackerleytng@google.com>
>>>
>>> Before conversion, a guest_memfd could be either all shared, or all
>>
>> You mean "in-place conversion support" ?
>
> Not necessarily. This is supposed to be :
>
> "At creation, ...
>

I've been thinking of this series as the conversions series hence this
description, David is right about being more specific with "in-place
conversion support".

I didn't notice that it could also be understood as "at creation" vs
later on in the guest_memfd lifecycle. I did intend it to be about
in-place conversion support, since I was trying to justify why we need
to zap both shared and private pages instead of zapping based on the
INIT_SHARED flag.

>>
>>> private, configured at creation time using the INIT_SHARED flag. Hence,
>>> when zapping pages from stage 2 page tables, guest_memfd can filter which
>>> to zap based on the initial shared/private state.
>>>
>>> With conversion, guest_memfd tracks shared/private state on a per-page
>>
>> Same here.
>>
>>> level, so a range can contain both private and shared pages. Zap both
>>> private and shared pages for simplicity.
>>>
>>> An alternative would be to iterate guest_memfd attributes and only zap both
>>> if shared and private pages exist within the range. Setting both the shared
>>> and private filters lets the zapping logic do that iteration instead.
>>
>> I mean, we just want to zap anything that belongs to guest_memfd, independent of
>> shared vs. private, really?
>>
>> IOW, it's not about shared vs. private, but really about zapping anything that
>> belongs to guest_memfd.
>
> Correct. But we want to control what we "zap" (invalidate range) when we
> do the "conversion". e.g., if some ranges are already private, we don't
> want to zap those pages, as they might have some data "populated" by the
> VMM. For more context:
>
> https://lore.kernel.org/all/114e2488-97ed-4740-a8e8-1edd991f26c5@arm.com
>
> Suzuki
>
>

Looking again, there are actually 2 changes in this patch,

1. Zap both shared and private memory.
2. Allow zap requester to request what to zap by providing a filter.

(2) is preparation for in-place conversions, where Suzuki pointed out
that in the conversion process introduced with in-place conversions,
guest_memfd should only request to zap memory that is not aligned with
the requested outcome of the conversion in terms of shared/private
state, to avoid over-zapping.

e.g. for shared to private conversions, only zap shared memory, zapping
private might destroy data.


How about this, I can split this patch as follows:

1. Update this patch to just do (2)

Commit subject: Allow zapping requester to provide range filter

In the conversion process introduced with in-place conversions,
guest_memfd should only request to zap memory that is not aligned with
the requested outcome of the conversion in terms of shared/private
state, to avoid over-zapping.

Prepare for that by allowing zapping requester to provide range filter
so the requester can zap private, shared or both types of pages.

2. In the next patch "Add base support for KVM_SET_MEMORY_ATTRIBUTES2",
   call kvm_gmem_invalidate_start() for conversions providing just
   KVM_FILTER_PRIVATE or KVM_FILTER_SHARED - no change to the next
   patch, mostly.

3. Add a simplification patch to always zap both PRIVATE and SHARED for
   the truncation, inode release and memory failure calls to
   kvm_gmem_invalidate_start()

With guest_memfd in-place conversions, guest_memfd can iterate the maple
tree to look up whether to zap PRIVATE, SHARED, or both based on the
range being zapped, but I think that's doing extra work if the goal is
to zap everything from guest_memfd.

Before gmem it was an easy lookup to check the guest_memfd init time
flag, but with conversions it requires iteration, and
truncation/release/memory failure aren't particularly time sensitive.

Sean, do you know if looking up attributes in gmem to feed the KVM MMU
the smallest set of pages to zap will improve performance significantly?
Or if there's any other reason to do this lookup (more complexity in
gmem)?

>>
>> So, couldn't there just be a KVM_FILTER_GMEM thingy instead?
>>
>> But I didn't quite digest how these filters are used.
>>
>> I can see that kvm_gfn_range_filter_to_root_types() does some magic to them, but
>> I am not a KVM MMU expert to know what KVM_MIRROR_ROOTS would mean.
>>

