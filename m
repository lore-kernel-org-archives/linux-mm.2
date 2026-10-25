Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DF23606A31B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 20:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cw6wxqO8
Received: by kanga.kvack.org (Postfix)
	id D99736B05B2; Sun, 25 Oct 2026 16:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D49C86B05B3; Sun, 25 Oct 2026 16:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C603F6B05B4; Sun, 25 Oct 2026 16:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9960F6B05B2
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 16:42:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F1C0E1605D4
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 20:42:35 +0000 (UTC)
X-FDA: 85362321870.17.698A244
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1B464140004
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 20:42:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cw6wxqO8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792960954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZVwpDuEOvVP+5WMptjvGUaD4UnS5xmh0v3my59uo80=;
	b=5qBDeTnNI7lF4ZmllSxTtca7Dnti6l0E5Gl780L3zle1WXvcpmcDdWD0WKF3jYZaADGAJ9
	mumNIrw6MQfKov7K4zdRuWe5Aekas81OpP0WesiM6SchQwOetkENC2KqahCvkX36ovFchY
	Wzznv6+kPjkHJje+6KCnLk47yJXltdk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cw6wxqO8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792960954;
	b=U1JoUKjonYmvD7G0gIYdhCxL2U1iLR8QVzdA7S4zX0z3Mu/N47C842Ly08EaVwUeOF/REE
	s0i5TNbuYbqoAyOMxYNhdcq9j9ZlkunHrJS9GXLsu4IKK7K+/Og4xYKbCkoKKM4EoiYs4B
	9yJMeCDYRE2VY3pYG6jO6zS6WpZ4YsY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF92743A16
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 20:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20941F031E4
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 20:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792960952;
	bh=1ZVwpDuEOvVP+5WMptjvGUaD4UnS5xmh0v3my59uo80=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cw6wxqO869ZZJ8vwwoDzLpFL7knGGLPUHbSAAQ1kpxEmlLRSoAcIyI+7nCNkPXtXC
	 /sQV6Nvfef8NOsj/Vee6+JjdQSwsL8eGsx0BMC/21zb7xTzpc9lozSJ7N6zZWF79VG
	 mhefi2f4xhIQUZOWJNQJMiZp57XOxhMYe7hXPq/QPwTT/ClZNZV7lCq/+2OFBWsxrw
	 7Bbsquk/ryxVB+AxDl4L4wPHsfXS7lFVdaIMIGn6/3nH7z15C+TgtIieL9xFC7NZ5v
	 Nf14VG1zxAGC+aQJ4EokIMh5+0zoWQO5PXt/cCcE/eP1BVl+c1l6nRpKjLzjRsrTav
	 8ePHU+mvvPfrg==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-93efc0452b5so156499185a.0
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:42:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx9QvA76YOPOY1ferXltiAvKtot5awe54Yii5eKnfUUKar+AD4+JRHKdU1pDK5KTWUT1tbU48y4cA==@kvack.org
X-Gm-Message-State: AFq9FYJ9JpjOfZcQyNC+OfHRXCFIiMkKRz+bOtd3du4pLlsvLx7ohIAW
	BhS5L+wmZmRFUvGz0OngqF8oc459JN7j4o+5tTt83ZPJ24mSFlZ+iC7QoeWby6FlST7OYcHMsBc
	DzjpWruwd66ACGOVKbbPZZLfJrlDLm+g=
X-Received: by 2002:a05:620a:400a:b0:93e:48fc:aa88 with SMTP id
 af79cd13be357-940ef95513emr790870385a.44.1792960952180; Sun, 25 Oct 2026
 13:42:32 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261025021839.1542805-1-senozhatsky@chromium.org> <20261025021839.1542805-4-senozhatsky@chromium.org>
In-Reply-To: <20261025021839.1542805-4-senozhatsky@chromium.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 26 Oct 2026 04:42:21 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wF2YfHwyDSt=B_+duiHCXke8JJgqGJcaw31JunUbxxQw@mail.gmail.com>
X-Gm-Features: AclHuK_u4ku4HYNTJ8RqUHQB0jHfvIpB2fBEVv08j0BZX4fWzV5XB72RUiMN54w
Message-ID: <CAGsJ_4wF2YfHwyDSt=B_+duiHCXke8JJgqGJcaw31JunUbxxQw@mail.gmail.com>
Subject: Re: [PATCH v7 03/15] zram: reset writeback state in zram_reset_device()
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Brian Geffon <bgeffon@google.com>, 
	Bo Zhang <zhangbo0325@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1B464140004
X-Stat-Signature: 4nspudrhzmn9k7rdro81cb4f3fnk3gsc
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792960953-285540
X-HE-Meta: U2FsdGVkX1/9vTuyMKlGpsM1hgUCYy5ugLedj4hd3I53gz6jKpz8IG2Twph5IKhxnGt2WRTRuWKcjbnw01QisMX7vN/fwz1/qQOx6cdZHbBwsB/K/dS0jf8pjFS7XFp+pltEh/hTvdUslaPdYukWKV4m0OChiUtA1467VMSFiJD1KCD7W6t44tk3t06neVgPmZCedWNRfWw7Rjpam3jBlAT9iS7BtH9Onj03WmCbMgIT+DmPmUc1zmAxwBT6j8C74jGlJVnBvOLTB6jv1yuchLspX8D88uPbapl2O1fPTT5DiU7TDbbQaB22yBR+WC6V03WuekosNK6aCTx0IfeCF+pJIaewX+nUio48CBCXgjr/dtHPwReG5/ab/SmqzkRq12rA4/jj8h0E8q3YwwXZ+Qvt+HMlqB8Zh+o1vd1V4BPeiX1hC7AP7EKGtmEM7SbqedZHQJbBQaDf5LGNZmlxjDOwm30aBL0FxMhKv4H9WMFd6Ibdv5SNdgAZezHkD4K7il1K1+mLT5fdw0cux7cfp/X8+8KHEtZ83JSvnSKS3hOi44lCNG6FItG+ouBLHfutwlb0vdGM1VJeo6QiUhLmm5bUgB6ZuM7zTIMsdi38naRsPjCuTZ0KpFSmKa6I+2qohv3YyOCkMR6nOwPWA05rxz7nxpxfx4vqpVtn7MDD52WJhLP115fm9zRf38jcm54+zg+Vq42ELXqSh9ROEF65XvnQX+XWvFqXUU4JqoFYHimFUOilU8G2Y6vPZISL/j1z6TlPjAHzCmRhYoHHfu4CxWaqkBLrE5IDjDiPMWWx+p70YkaH2XDva0QdRHdizbWRmEvATRJ1alOL0aF6khkkvhjCXjxq4wZCLKXPXtb3VmQ1N97aE2rlxXeGqhvbDjpZNoBx2rA5FrRoAzctxzz7vXQ40m4qp1X3PsP5WZFqwJ2Irc68AhD7bnfXQiPXqEK58CyINZqxHDoPd5gVNix
 KDBlkLFH
 ZobFlxPxv2ltqgApdINz81xCFyw8r/MNWAwGmxBWaQTry0Lej0wig4+u216h8w7yq3sjYXAHAc6MIaprlRvBsJoe176AwcwIHcesYFweV+VydR117lxUDjgxq/NJRzIfq85qwSav3871eAntJjvCCl1RcoD9+BYvx38CqtECQS0hOX8CaznRyaw49dfTAqeXUqa4lfj/O5ulFDbjg+CzSuFWUNl2vEn4TwJV64adsGJM5+zkqjS32vkJ6SpG10LALvEfk0XWEjQZVZIv0PbQnOYI7rG3oIcCAVPvDyTWtms31VIljTiURzp8CCEgj5VMnHjmoyvV97sKC3PTDVoR9PMPbYA1mxZP69decQ6WASRvRMYVIeSRsFlMHeTBFKdY1w5FhMjiUvmaXssdMwGi5YKO0gQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 25, 2026 at 10:18=E2=80=AFAM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Reset all writeback state to its initial defaults on device reset.
> We used to keep writeback related data in zram->stats, which
> zram_reset_device() clears, but commit 1d69a3f8ae77 ("zram: idle
> writeback fixes and cleanup") moved it (along with the newly added
> wb_limit_enable) to struct zram, after which neither of them was
> reset anymore.  wb_batch_size and compressed_wb, which were added
> later, are not reset either.
>
> The patch is more about just being pedantic.
>
> Acked-by: Brian Geffon <bgeffon@google.com>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

