Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A498CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E21126B00A0; Wed, 13 May 2026 11:07:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF8CC6B00A1; Wed, 13 May 2026 11:07:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35486B00A3; Wed, 13 May 2026 11:07:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C090E6B00A0
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:07:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71510C07C4
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:07:47 +0000 (UTC)
X-FDA: 84762726174.15.277122F
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf07.hostedemail.com (Postfix) with ESMTP id AD6374000A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:07:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=nUa8RY6v;
	spf=pass (imf07.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778684865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=evfqGNz0nsVJ8plAAlmr0vtrg9gduvV5egVZ+mMRUWQ=;
	b=lwmjxFECLMCPCScRbbUqRAP+SIeHQkn+QgwQisvXgVVFhIHQFoAzCz7lAWUDrIlQ4POP80
	l1lFsVQxId53KQQp+jWXCRLQvRO2Aodb+E6PoVSP65u2GQer72F9CCVW1f7CxK75iAKvyI
	Z+9PQFP3FzEt97sA0SQsr/015/VAgdQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778684865; a=rsa-sha256;
	cv=none;
	b=HXynuD91WvOiVMKdjoqRa6GkqtOpA/Ah+RO3qLSBO64g0jqETOZSdJc1kADAuBe+OJCK4R
	N8KIUVN4LAdU6rgNoQ011vLXP+sMuEAfCPo9FkkmWMtHz+d8RHD6Uu0sn4hXD/rPjcQ7o9
	32kFgFA0y6I16ezF6y8BAVRFye9pM9o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=nUa8RY6v;
	spf=pass (imf07.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=evfqGNz0nsVJ8plAAlmr0vtrg9gduvV5egVZ+mMRUWQ=; b=nUa8RY6vasN4F1beCxc71NJLPV
	GS/zA+0YNRUxQM+w9SsSOrQ4QibOxolEwvp1R1Yf8/kY7VGz8l/3oPDDcXdSIX7iw8mOyIgwve8ra
	/QLSmFWd8l9W04J+aHO6EXdQ3oZSa05prFU6udPm6LlI75vao77xp7en1FspKqvYXwqlNeITlV+FP
	bHao4TiyuK78pJsh2fHe/WhEK+4g46JcdHvK8Ug0zDbuOW/BCDLX+H6qpuOKQevy7oIIGHz2KELZ/
	4wVkJnFrU4cIVS3TSuMtptbLaNJPTomYWewUTpFI4YiyfOjCXC64xLdd9ktVyBMZUyRFDq5LHe/wl
	2CtrCBng==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wNBB5-003FHA-1W;
	Wed, 13 May 2026 15:07:15 +0000
Date: Wed, 13 May 2026 08:07:08 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com, Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v6 2/4] mm/memory-failure: classify get_any_page()
 failures by reason
Message-ID: <agSR4oLjz_B40koq@gmail.com>
References: <20260511-ecc_panic-v6-0-183012ba7d4b@debian.org>
 <20260511-ecc_panic-v6-2-183012ba7d4b@debian.org>
 <28b01c14-3d87-4cab-b695-5b9015578785@kernel.org>
 <agMpqhpgmezqnaA_@gmail.com>
 <3e5e8fb8-6957-46b7-9777-0ed1bff1d0fb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e5e8fb8-6957-46b7-9777-0ed1bff1d0fb@kernel.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AD6374000A
X-Rspam-User: 
X-Stat-Signature: 9uhnjfob3qu5ni7cemu3jctdm744m11e
X-HE-Tag: 1778684865-460723
X-HE-Meta: U2FsdGVkX19PzxmETtWTwRjN6mxwwfYv5aVdJlvXRmMAtcSe8GVs++sBqFJTDGQX2IR6Uz/u3yP52fd/XSGia0nwdTnR652WwV1W1IL55Xo7YnDoxTxVNhbjXf37fgsKueg2kczCvYNNeAfg6uBn9k4p60LdW2cNQfHVD2Q0bKDdjAS8nOPnuLWBGkmZ5krF2UlQGOfTq2KaBnaRsR+7PuyRwfh3MzFNl+v7zS73lC8Mwq1AYjf1ygmS/8KD1ME4RmGbPfAGFT9fyKJNft2VIiXfdHYGOBp/lp1cMCxhCiWqpRCksjRe0GnEF2DMY2FPcZFtiL21oc8G728rRgp0XCOqJdvMTYbeCOi/7Jre9EChDaZYSdNtx4AyXk5a4XKhaSVm5iUO25li4q9nZV50GTkkDHZ9G/hqVPVsllTWQKmovD5ynr2NsxXwTDQZtM5VLIVZuMBA0+uIkFj8Pw4Q1I+EX+LdZLt00Y4SBfokpYvn7K04Y08bKXigU/enCrpClkaoVQGmDvX9jfeJp5NAfyChwNNasJCUV8ESjNgpKv/M2B1q1L3Jz8vNj4vjQtXHAXfiICWO2Ne9tpOFDq3Us8H7Qt/yG9fey1m63HHTbxjd/Nx4B/NnHBP21YHDJkA4Hi/T3VLcCkcaLbN8dFDJG7OMCtZE7QaLQgZgqVxG0GgHxrnwpDuwLUSdpzgzjN6WDNg3jMAhYyq1F+zbTUD4IymitSTat7LAA2vH/4p88X0Cg+g3FahnbxNmE9H4DzdINTk73s2beNlXF0IEnmq07Mw1xFDnvPtNm+X7mnqCDvbCoq7MakCpFUCOLF9IAOxh4PwG9sw4jMKWggL2ahSqWEZq3i+VSjXy7y8vDeJkl2YkoDMLoCOiBwixKEI4rsKMHoQEdKV6xMm1PJoAtXPB9vHPffFMLgwU7W/ZPtMzD1Taa17/+SBqnjBags1YDw5hDl7B6fpxIwJT8Kk02fB
 gvOSsjnp
 ZmsHQEW/fkK/FoaW336NgJfByDGdZ/rU+z+SaDdo/UDkyfs3Zl6sdjpG5sqsRJEUXqgjeDpG7e8FIwo+qNweTrqDJl0zTa0CvuE9+5mqPp+12nkT69+dvLGskYON8pG8xqaK8KlAf+MtSkINZlC9STLz+1dI43n/oaVHx/C1beuPIYCSvaW/yOv553U29GN1dIEezyYLXXWBi+YuHwluOFSQf/eIH0AXK43pN0hSJHZmTL4pjk87CNLqhmUwsfFWCn2TxWGE3Qt0S3i3j72quIrmGhBWIy+bRmytrwlPpxmxCKE4zLZ5Tiuxg0zQkEgA80cLl+txTAogdLJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 01:48:11PM +0200, David Hildenbrand (Arm) wrote:
> > @@ -1441,10 +1456,10 @@ static int get_any_page(struct page *p, unsigned long flags)
> >  			goto try_again;
> >  		}
> >  		put_page(p);
> > -		ret = -EIO;
> > +		ret = -ENOTRECOVERABLE;
> >  	}
> >  out:
> > -	if (ret == -EIO)
> > +	if (ret == -EIO || ret == -ENOTRECOVERABLE)
> >  		pr_err("%#lx: unhandlable page.\n", page_to_pfn(p));
> >  
> >  	return ret;
> > @@ -2431,6 +2448,9 @@ int memory_failure(unsigned long pfn, int flags)
> >  			res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
> >  		}
> >  		goto unlock_mutex;
> > +	} else if (res == -ENOTRECOVERABLE) {
> > +		res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
> > +		goto unlock_mutex;
> >  	} else if (res < 0) {
> >  		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
> >  		goto unlock_mutex;
> 
> That might probably read nicer as
> 
> switch (res) {
> case 0: ...
> case 1: ...
> case -ENOTRECOVERABLE:  ...
> case ...
> default:
> }
> 
> > 
> > 
> > If that is what you are suggestion, maybe we can create another
> > MF_MSG_RESERVED? and another return value for get_any_page() to track
> > the reserve pages ?
> 
> I guess "reserved" is really just like most other kernel pages. So I wouldn't
> special-case them here.
> 
> Or would there be a good reason?

Not really, treating them as MF_MSG_KERNEL is sufficient for my use
case.

Thank you for the review. I'm digesting all the feedback and will send
out a new revision shortly, where we can continue the discussion.

--breno

