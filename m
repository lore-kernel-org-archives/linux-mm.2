Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08A67FC72AE
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 07:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44F356B00B3; Sun, 22 Mar 2026 03:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427316B00B5; Sun, 22 Mar 2026 03:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33DAA6B00B6; Sun, 22 Mar 2026 03:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 220936B00B3
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 03:49:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB6E31A051E
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 07:49:38 +0000 (UTC)
X-FDA: 84572924436.30.BC68E37
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id D91F4180007
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 07:49:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aXIWDUUb;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774165776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yog4Y4FnY2pw/bISePo6mO0/0jBCwWfyVov9mO2pTgg=;
	b=kEFPBumN4bl4c2g+UjuA9kk7M+kaKfQ1V3cBA6Vh6j2ICX9SB52/xnLbLRg1NeYIcWjAvW
	5XOmV1l2fcwviOOsXvFxeiq4+XmpILuWtneNNoVWJS6vPAhUlQC040Qf3s03/9a23qHN6M
	gtvH8VGdUYaucZPpJ+cfediMF/oQwkU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aXIWDUUb;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774165776; a=rsa-sha256;
	cv=pass;
	b=lnnCNPGieoBzxSYepKLYP91DRuA5WqBvPIg3TwrkY/7erD6KGvh3eX15N249AZ9AiR7jCH
	FvNe4ZXHuf9CV6xhTERje6DHgH8oOEAer+gMhGLkzCR3FQSnxchEh5f4zkUExp6G/+O5R7
	jdYwnMZpOOTBgAzbrF7svM6YvQ792H8=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8cd7284782dso231396685a.1
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 00:49:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774165776; cv=none;
        d=google.com; s=arc-20240605;
        b=aJuGkmyoQIX+V6uW5iK1HvQWEF8kZjQ2ZLx7HNPuMxPiRs9IDzEec6ee9xytiV7GnY
         oiMwOE7DrFBaXn7EmQdvJr9+RKT1sSPEK5DGpfUWX9i55EqVIM1zI5KIapX1roHcIV5u
         EYEksDBrRcLDJ2CZzZ/Lfzd4AcM165SgjRQju6eRmPFJNARbdb/iDuxyVpjx+qgJ8c3G
         CN87HOwMb36krOb5b+Rvz4HGRURMfdtstD52kz80sT7DhQZMJsRTzNsSu0dPIsRlvn3D
         5Bzo+wDZIjVjB5jAnKqnU0mvigym4tgM07XjXhAON7F8228gjzKpMCBb3iyX1cXcb9Va
         9qDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yog4Y4FnY2pw/bISePo6mO0/0jBCwWfyVov9mO2pTgg=;
        fh=sHubMJb5pe44eHzZIsI7Od1lDr/BxUiLi3GkYlTwKXc=;
        b=Im9/7RnTnZUY6K0p/NU9E8d80vCYF9yq3m0l+zPu87JOvUxZPhbPOOYptGECXceRYq
         yRnQd3lRbDBbAXo2qyR9k1HAJCa6TmJwaLuxxHgxnyiOpdGwaBqxjbIKrU85EJeeuyyu
         nwZ18dj5KBAIDSTTOVOelpfaEnRBATkM7MnTJQTLTpIcvYn77kmxf3rF/wDxU6hUKY0w
         C1um3MhsNeTJRtTJ88LoNisbMHi7O/yAKXYCwm2Klb40Mk7MdqbJZKxpXnQqIOIXLPqx
         49bPjvWBlMg5W9FaPEyTLuqiUSOdjlrnYrd2bibP00eGXEqkYVNXZSNlRbMC+v3T8Mri
         q6eg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774165776; x=1774770576; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yog4Y4FnY2pw/bISePo6mO0/0jBCwWfyVov9mO2pTgg=;
        b=aXIWDUUbXEzeAkEm7/zDFFY95V0v+j/d1RcRC+Edvv3P7XL5magMqEcUgoBGHeZ/qG
         EZZ/tH8PmqdL+ABgY/lSgs6i/d7baEhw9aa2hRjop48hh/Wu6qsCQIM0tKH3zv8Ze48g
         2auq8UbJTP9hislM4MNByVMMCz7Q9N2UIoUj887Iff12wp6klA5fhImPywqqHtMGKHqE
         CYTkpdEbhVB/xe0eZyyEWculEqFYpEur1GDOlONtKm+6z39VbZ3C5hRP/5O9hVh7shhj
         UKp+86outNQINhQahhYXHIHUP9TNDvxqCEyaGWDJt9ZcOcIby4GzLofjM8KTxcoJ/B1m
         zgZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774165776; x=1774770576;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yog4Y4FnY2pw/bISePo6mO0/0jBCwWfyVov9mO2pTgg=;
        b=iucBaKLdcQeyXCYmjJTwuSUGTnHdr7QS/zUkKF8XcVIy7V3HL2oOX7iF77NULPSeAI
         ZIcqcfhZRxamFDPlXCWXQPIdU4e2SOzILiu8sUhcJ4dI2BUgMZEyN82GsQmiJyhwt4HR
         gixpKP63/bknw1rf6HzE4ltiRnKm4lyJVrDE5DDWWbz4gCV/P7BUpzWcd+jyTRjGZL/c
         O/2pZob6OFg4qB7Snlq+AWhncF/ZPSTY6NKknbJ1uKyZs8puLnhyXwLruwwa5dkrzyjE
         QC6j/Bz9U5EzyJZxGz5r+5Cvu87v1jNiSjFTuPMFlZSfCWbEQjQ9kzYMfXLfMNj5NPT7
         +XMA==
X-Forwarded-Encrypted: i=1; AJvYcCWRBZGv3jiIdzk+rGTe41EONiLl1DrfWjmuHicFHxJBtQ8zOGGXsC5XuElBGzBUj7LIwSKyzEvhiw==@kvack.org
X-Gm-Message-State: AOJu0YzEWNbjL9oIBAtqEUglY7ajhgQKjJoJg4QKfOgFJYdrVLqz+fy5
	IBBsNYYPqXRtPpLoe+4OO6vS8bhTBWqE8uLyV+EmUoAIfG+B7CRCI/6ScW2fdENw2t1fdrh6cZJ
	MtcKkX0pBrS1L9r0SFVEqwcz4TRcv8V8=
X-Gm-Gg: ATEYQzyIbwu0vYQlnNTmNSeNsFkE9bPtr4DI/GHWGp9hjA7bB64NCXJKvQG2mruXNzO
	WUNCHozSgE8SFt00IPS7Y3lJA6i+6eWhI0jUZGGhYuAs4Ia9HbTdhUpRlcJzifWH1FlHSR+sESt
	mJncNTsTS6MKv7GRv/xk76ddQ+QgxjMHZvjuZGDWvYe8SbAY605tC8ppCM7CldNSl/7rOEL7Lyr
	4B1H35bJ3P4QmlxJwsoyhQ0IjAMrg2veZ3wM5qHNrPTSgSO3hG2PiLkXbH7sHAEAMz5CrJHunQs
	MIogwf+nVQ==
X-Received: by 2002:a05:620a:318b:b0:8cf:db7b:6224 with SMTP id
 af79cd13be357-8cfdb7b68e2mr439093885a.59.1774165775634; Sun, 22 Mar 2026
 00:49:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260322054309.898214-1-surenb@google.com> <20260322054309.898214-2-surenb@google.com>
In-Reply-To: <20260322054309.898214-2-surenb@google.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sun, 22 Mar 2026 15:49:24 +0800
X-Gm-Features: AaiRm53R0BSIBZ-7kcLpHy3OcZIzoW6AMt3M9APBFS4L2dJIHsEh5rSFscqFXrY
Message-ID: <CAGsJ_4yAWxty2PAm0Lp-iDnAm6DpReedRvus7FFQb3A2dKPTYw@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm/vma: cleanup error handling path in vma_expand()
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 185rtb1jcgzxacjrany8m71w7qxw4m7e
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D91F4180007
X-HE-Tag: 1774165776-944131
X-HE-Meta: U2FsdGVkX1/BnUyaptC+ZdFk51FHEgkdEiLjL/lpfJOhO9qvkBWj5fu4j8UZOWsnSYtcfEjgSVnwisqVoG6BB6SJQHtge3ewLTEiu6c3dHnfHY5bXahyIxCmn9229RklPJCdwrubgGn/IF77tN0TxUapKfj40ppomyg+U4wmb+AA95AwODMMOv+UPawn0sb9t8yLHs7/KHbuWXc0g6HLdHbixAu9sf/hlC39BfHmqMcTZSAbpT79jsweqfSbABkk/HVgZMFqwilEh0aDh75LTCncWrn7Lvwrdx/JJZsHgH46lAS7AwoNh6Do66XA8IaMzr7lqPUY0x9NSH+1jjYII0vo1zX7o8MxvfjhT747T7sbYSkgj+SUtr7g0OGhtE+qaScYQAVfURvlHwFdUtbnbCSAcJNTxp/5AHeSuJuBiTS8CvHSt4CHj8GzJksPqDi6nleyrSJZY0qb1J9C0CvAZCDYI/9l4YPIIkEH1rMJkE144HfQY4EMKKcNmxC7Uerl08512r8iDIeeN4cJgdUA+feanN0feewDiL7OuRxOjDU1RJfvxgszM/1K7Z30De1tXEVsuZtt2Tv+nNxVrn/8HZZHtGm7CjoRP6c7M5AToKPWhM0M0kKVsnRnXx8O0OODpBZn83cQ4tsN8CznEzPme7rs4COog/H2xkXqvDDboXqXaMX09XpJM7d7Ro5nUdmoMfS8W3lHfjWdZTiKA7uJxsUdgjxrIjDXbBOhrMKr1Rv5lcEPMwoqSpKvkqcgl9i72byPMSj7yNemQdx13jxJJLE/RWaJ1GF5MINm+wKxdvLECJgJPHDTdtCLXtqqTpMnw5Li2bQKO9xmPepkZ/TdRr7n1Sm2Bw0WbO7bCv4nL9ef9XBoox/9CRtphrabH72/6RSd+du6S7fP8XTU32Wzr8b0FyKa3Y8fj+gwDoKcpJAIbZNuTb6mYqi2n1vltark/NL1kjOCRbsfZ2MEtyi
 t06L6ZCj
 jlo8Of7rJXg2m5mnlp34XG6gddYEpdi/I2l3Jnk69LS8VUS68I9JARfx1/0vabYNoTno0K1xxI+VHnlrnnDmMEqKSBcfp228unt6mXN8rwmmqaI+y/HBaXv18GMj9VMvW7N6afoP1kpEk6XMjC+Bv1BJHi2JH4Sg/NM10YG1QyyfrPZFMsY+ucfYd2kW/l1EFcEaLuDgnKOmMLJbeseWk88uLpQZXDeGK8BS8iFg/T33lVBv0sHppfoBTAhv6ixkSzeD+A1CiqhxxqVJOfXBRS51T6ti0E4rI05PLdaci8o+S1oo/Bl/XXIY73OpJWRet2TJwLN0Yz3eK5bQCAbP83Jf4JgMg3PylvkQBXyVY6zGHSM8wXoYtC54XfEfpZsS+3xQB1HGVwwWwESYgTGFu6NnPuWC9C2ABMVjAQ4k/mB4L4seh8Kmdc0y4wur7bkryZXrJtN9zxTS0XEz06EwrNQLdyjDOG2oOtqCwaFf7aBZ2zOYZwqLrOp5GlTyxjd9J5tSrnwzNrheoDk3ERotYWrq1xHBvksyG23ZqTWQGG11HJ0Ewsh2TwI4BBF0eVR/n3GP6cbGLoZUkQgs5y0H/qGfZyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 22, 2026 at 1:43=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> vma_expand() error handling is a bit confusing with "if (ret) return ret;=
"
> mixed with "if (!ret && ...) ret =3D ...;". Simplify the code to check
> for errors and return immediately after an operation that might fail.
> This also makes later changes to this function more readable.
> Change variable name for storing the error code from "ret" to "err".
>
> No functional change intended.
>
> Suggested-by: Jann Horn <jannh@google.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

LGTM,
Reviewed-by: Barry Song <baohua@kernel.org>

