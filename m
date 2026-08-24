Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FDBFC5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 17:06:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A427C6B008C; Mon, 24 Aug 2026 13:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3806B00A6; Mon, 24 Aug 2026 13:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E2EF6B00A7; Mon, 24 Aug 2026 13:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D9C36B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:06:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EBEFD1601E8
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:06:44 +0000 (UTC)
X-FDA: 85136792328.26.3A703B5
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0D7D1180005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:06:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VJt614Rb;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of jannh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787591203;
	b=mEo3en6ID7er1rYb4xieUeuRK9ituokTGQBB/eHKfTB3o8x8U/r75a1yHu15dwMQX0y85e
	nyuEk8XzISdts4h/BcKPh27Lq7ncvl6dWtiJUTMD3uERvenO2fatkKLgmuOCGcK/INIA8f
	RwnVTWwQuFfbOoRYyyVZiISh+xLP1js=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VJt614Rb;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of jannh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787591203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wBrui9oca87xmLJo5FCru/sywwEnBCWCZyUpBYfq9bA=;
	b=dJn6/6N2iBBLkzUxsWhRKfx4khR+vi2IcvdsxFkblKXsxgPakzY4Kw+OiCQ3NHe6Blgfjd
	Y8+rObTlhK2ozwhGkqpSK/oI8XpinOaePvb+7PTHPvCgU2mDyP9vHPKQ3hISD62htA1PWQ
	9HB88TXyHLyiyrqFiUU5UTNvc1g5A0g=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2d3b445a84fso2485ad.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:06:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787591202; cv=none;
        d=google.com; s=arc-20260327;
        b=QEnoeUYsX61Sea7x69z/Mzg3bemKgsxnc2dRYBwEooapdOFyquKsrT/4OCNn0M7dD9
         uSpJ3gRKUKtGWc+Bbag1fV/Ls6cXV9BQOEAv/Rpi8rTF84A+nchKlItP7PB+ri5WrXzA
         zf2QD/Bb07R3VhT0MV6BOB7IPjzbsP+LLl5ZomZJ2l+NrTRoxbBGShvQUzydQT9D1yPz
         gzRxZuBRf4HKYEzxMFu1KjGGBcMLTCB81oou3TTKMaQfibLlszwKcGPak5NR7vUXcHpz
         y0BK1u5A9nWG2Y76f51DLY7qGvGov0iHvP6BWvneVJjwCfcY1M6NMMMHsgX8nRhmRJEo
         HMdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wBrui9oca87xmLJo5FCru/sywwEnBCWCZyUpBYfq9bA=;
        fh=FwUE4cvxLc+vrIYEEWkGK9zfdEYUnu/JXgsqmlpQwYQ=;
        b=UyogOEKKivGdfvKQNLo0/NiKc1ZbA2plFf+qp4fAYzAI688v7HnJalRM3lErhR5FbE
         nvnYrNOwHLdoZfvy7F4yTUXOs/0ltxmZGQ8fGwXIY43Nfumhp8MSelFboHEGOAPnwJ79
         qDZrli3qOHb4zxGEhLCl4iqHldqJtOcnwllWSqXd0Hb159mFI3RKGnNt0CD6mtV6sJoT
         hGoqoKurshTqwUcgMizcZP4CArWOah5X2hBZxb5JDib2G9iLKtVTRQ0sWDVRe8F99ewv
         xmdaBH4pIvM9f07jUrkrH5eh5Zvj/LJaDQhAv2AWszuU2/uswXTLEE51fFtMOuEwKCZh
         3MxA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787591202; x=1788196002; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wBrui9oca87xmLJo5FCru/sywwEnBCWCZyUpBYfq9bA=;
        b=VJt614Rb/oDcWSgK+RZnW4wv3wZcV3N8nZxEmc6Vp48LdrZ2qzjfgka9ohXfoICVtk
         B2BkHh/xRTbvYLvlFfTKDEQp94CCzYKAPOpbYxT3Ah1VQGjKjNYRPdKVk9lFkoc+iH5a
         y4QKgDBxBpNIo5a1PIAT8/dGmZOP/U/WsyDNk1BEC5q7D5o2n3JQXXFuZJg9vC0qaj3M
         hqJlGhk0xY8OEivAfcCjQdLnCVXG3IZGtbqsmXJzn+2gemZW0MBBR0DU4BDwg0tEKKEz
         j6IxKap46hMjJ8zUGYVhtixja2lgck1O4PEPTrdUmviAmNh2EQe9cRmCBOFPWag2XDY/
         1wIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787591202; x=1788196002;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wBrui9oca87xmLJo5FCru/sywwEnBCWCZyUpBYfq9bA=;
        b=chHHF3WpND6BcGF1lx60Gw4jZE/40nAPkZ1/jRHQT7wTZxJkoGAPs6NglWbV3tkS7s
         EesXQKvP8ZksfOUUADoD5yXMml+6Av0AlTx6KP8coCnQEyM7COqmO5+uEeqtKyMpQOVo
         8Z7xImxdTpH9gbhDju+i69STymoYy4NqXMz1SKE/Hf81ej/w0ytblTeDTtjowR+wx8GE
         8LP4LSUnriZ851Ql/jgTzpuwUjXiZmQshlLQWPx5Z04XeJ92V2DNQ2763SiBCnq2hL3f
         7tOdHJwZMph7iSINefb2+MfW3lxytR4/c4lEUB5EAMVOgTHNq3OQpokfWGT5CIwVWYpb
         huIA==
X-Forwarded-Encrypted: i=1; AHgh+RpY+lsKdrIwp7COxhVf1HbV1s8dOiWyNQrz936VmvdnRJ+C0YyIzS4xoNj4XHpb1z6Ou/w7NeJ5ww==@kvack.org
X-Gm-Message-State: AFuF++lDxoV4OfeYQ1oiyuQMxq5SzltE+5j4LvIMwGfm6lxmZFDaBf6i
	nmUNyhYnzAqe0E9DBkyyooyRJvdZmTZgvgRCrO5M4raIoCEVx5uEOtdIT59UUTA8v3iNBOOv2ru
	auwTijDEWbB2msehcKksVrB8p5RdSEb0o79OfselR
X-Gm-Gg: AR+sD11JwOiGpbc4/2l/wNcO7DyjFxkzVMsfkZ+u/6aHV7/46aRtBUdqSHFIJh4ZSdp
	EuBPGpT99xhr7QmdoeOeFwGfm+W+ilAQcgp8wMqKgHjGLJtcaGYGeDbfs5gnSL5+LnOqm+SOCCG
	2X4rAnk+3t0QDtVD14O3X4piAZ3eSDkVCNOoUWKhk7XeiWCEqzJsAjq1OFxOMXcrcNk9iyIV2D+
	svtG7S9MIJO0B+8s6YaWyg/esgHC8lYtWi2EbOYkKDDw0aXXg8j7h+aAFqcBkXd4QThM/m36HNA
	7+AlGYPjBDF0EZoBp8MWfMBFXqOs5wZr7nMV7Gd1+DmwsOdAfm+No1HLE8Corl7jVLR+KKn1/+n
	q5NnVTFltD+yngCzepkc3yVpXzFXBzmE=
X-Received: by 2002:a17:902:ced1:b0:2d0:1aaf:daec with SMTP id
 d9443c01a7336-2d673b9afe4mr10236935ad.9.1787591201205; Mon, 24 Aug 2026
 10:06:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com> <741a833d-6889-4ee6-9322-d6a3a8b95893@kernel.org>
 <CAG48ez2Ngo3=VtyykXY6ynVzGwA8px-p4zV3V6U=YfgV-Hy4BA@mail.gmail.com>
 <dd8c34a9-0e09-453b-88e1-0a5511816627@kernel.org> <CAG48ez2bZEV+3ww2x9XV_5vRPZ_3jU_zg6+h=BDKQ94Xrd3Tqg@mail.gmail.com>
 <aoibvf6CY99IXynk@gremlin>
In-Reply-To: <aoibvf6CY99IXynk@gremlin>
From: Jann Horn <jannh@google.com>
Date: Mon, 24 Aug 2026 19:06:04 +0200
X-Gm-Features: AcwNN1XN1HjALO-7sEAr3yIwV5QVslvlMZpManf5842ZQgDGGQ6V_1u_W3SFNwE
Message-ID: <CAG48ez0CX-PT5Yk5gYJuB6wPe26j0gHHXQqYoNtTA=iHe_5Wdw@mail.gmail.com>
Subject: Re: [PATCH 2/3] proc: query LSMs for introspective mem access (if PROC_MEM_FORCE_ALWAYS)
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jeff Xu <jeffxu@google.com>, 
	=?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0D7D1180005
X-Rspam-User: 
X-Stat-Signature: udea8tf5yzjmg1cag4akum4wkebaqxgf
X-Rspamd-Server: rspam06
X-HE-Tag: 1787591202-110797
X-HE-Meta: U2FsdGVkX189/5azr41z7QCbT4E83nutwvEUSNsw+9I/eVteW1WTVwegnxq+jXHk9SQ/ADQeDOOOzxyTWfhjciJ3N6uZDgtaNkLP7+al6YYvBI+NWE3kulZgMHwiSz0vVQnMoYvGBLNYqZBNorge8IXtjrJxd3jcHNBfv0Tw9I2J5kYmIizFKhwVEMoh6YIFERRGBjPOQcYaMB7IXG7joIPl059NSBtUDf84EJS2biZp8gdv/eolpw8FY94QRZDDnBYj17/vOwtI7oqaOgqUYVaew7LSblPvMNOQDeXOt1F9uoNR1MKrVB2egCH20R0CsrgnKq+y7iaFyqZFTeRjk5QaEfc0GbRju3Y2rX5tWlcRf4wcQMBCGyx4knMowD0utFFPMs0SiIMovND7sujkSY2/kHtYmvt6ZGxAzil/EPeQWdBAisyX7YIoJph0owRRMl40MaUnDKmK70UgcdBrRMFbBk0U+9doGFTNktB5AmFrgq8oGwyctphUcK9FniC0rJvrMKWKvRVeReifL0Mh7k5WCajqvTvKUcsvMcrg1/onfqE4K4kpx8X3JrUV1hKCMk+wejl8ifXldJ5zbDPxtIgORdPb90enndAIH/d2NEyUq0NZ8Sllnj1uSNAYxVPhPje5R4q2Kv/D/wFfG+pMnhw5mfvPA3KVGjLjDYZjr1K3xX5HDlQiFKnAgWB+EAVpr5ND4zOaEL2+21wdMsUBU1zXvQSA4+LV+4pjTlq1olm4bnng0J28YnbGnxGmX+ru52hvRQn1sNXy85rkfvY8h/mUJh7eXVbKANkVvu3gr7hQAc80owQk5g+eb+qIHHQibNVu+6ccW5VPKRX4CTtrm6RwREfcnAeMVfpYnjDjXk+m4viIjsnnpuEyUASXKz/r1JlzjVUxNgDUuk6AqiatomdcvGTC2qnWDUkO60jnTb09XShJSGUKFIjdsEjj3jTrv/VBRJECTI+uMIALU+1
 8Um3fpec
 lciuCKsFfAkDmM6WgNHWKojWQTHVYsEUZ6RI+n82tVR+CmodkXj4pnLNPeWOquNTFdhclLrglNTrmoZ51OUym7aLXbxtVJnwUsCnoyuZNxFMbIn3hHJrO7+EKTcAG8yMMuNopYHjByJ/ACD58hgyb8SohKgHzyR3DnMUUiI6iVYe8u6gMnC4uYIY2RFBZyEL8wKCwa2UyP3pnisV4Jdo5XctWZHc3V7VG5zfArISru+CSFnlln56k1tly3ec/yOyPdN8LS4OsdyrFM+Z9CxY3aICMuIxXH6ZX+Xje92hWr0ecv4x/QEOpQS5k/Up//siSot5U+8wJK7bIbRGt1uqYskqn2RBApK706t2YX5cA+N53Oazaxj7fOkELZQMoWSjn56Cv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 8:52=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
> OK so the whole thing is:
>
> mem_open()
>   -> __mem_open()
>     -> proc_mem_open()
>       -> mm_access()
>         -> may_access_mm()
>
> And:
>
> static bool may_access_mm(struct mm_struct *mm, struct task_struct *task,=
 unsigned int mode)
> {
>         if (mm =3D=3D current->mm)
>                 return true;
>         ...
> }
>
> And what this flag is carrying is 'hey the reason we allowed the _open_ i=
s
> because it's looking at its own address space'.

Yes.

> I did wonder if what you're protecting against is even a process updating
> execmem _it_ owns, no fd shared anywhere, as something LSM might want to
> prevent even so?

Sorry, can you rephrase that? My goal with this series is to let LSMs
block a process that tries to modify its own non-writable executable
memory using /proc/self/mem; I'm not sure if that answers your
question.

For context: In this series, I'm using "execmem" to refer to the
SELinux permission PROCESS__EXECMEM, which essentially controls
whether a process is allowed to create writable+executable mappings
that can contain anonymous pages. Additionally, it blocks creating
executable mappings of S_PRIVATE inodes. There are other SELinux
permissions for things like making a VMA containing anonymous pages
executable (FILE__EXECMOD and others) or mapping files as executable
(FILE__EXECUTE). FILE__EXECUTE is granular, it can be granted based on
the security labels of the process and the file that is mapped.

> The sharing a /proc/mem fd seems like that's a pretty dumb thing to do in
> general :) but I guess you have to protect against that.

Yeah, it's a kinda weird thing to do...

