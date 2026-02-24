Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E2A1E9B250
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 12:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FE036B0088; Tue, 24 Feb 2026 07:09:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A1276B0089; Tue, 24 Feb 2026 07:09:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3628A6B008A; Tue, 24 Feb 2026 07:09:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1FF3F6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:09:30 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B2567140572
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:09:29 +0000 (UTC)
X-FDA: 84479230458.10.94F8B38
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 851F92000D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:09:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="X0b/NGlz";
	spf=pass (imf13.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771934967; a=rsa-sha256;
	cv=none;
	b=NKyuwSgrRy8LoovaxKp23W6k1E3sdyJJlB/QeZwyY+Mvjt7JNWpd/4+A6LzwedGBg2nPcP
	70ylMFIt+nz77YjQntRqHTSXfUZ9JFAPf3T5LjzMBYrOG8XS+kxTqaCBXh5aVrOUCDKpn1
	dHPGcqYJ4LGi7cpUVX/PkVAp7cGahb8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="X0b/NGlz";
	spf=pass (imf13.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771934967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PTr9nXa9KbUpiMsj0WnWMiP0h7dOygixjZL8t8aHz0g=;
	b=NoqcTQVYkn0DtBMMFvr9q+TH8h4JfjJOqmdW1cfTsNjNbQ31WaLunEEH55Nzp4/m08cMS4
	IYh5F7JJ6E+0jtM2Is/aP6vgPXF5HDh5ON6ETVhCnh9Xn4k9Wb6NbzniuV0YPBtzK9wdrq
	PW0k90DBy+KDggPIZ96ezGGTqPPLgFI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771934966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PTr9nXa9KbUpiMsj0WnWMiP0h7dOygixjZL8t8aHz0g=;
	b=X0b/NGlz4AmwIeahIYcz9Qr961jpjhWLXEO6599719LiYPahLZ5yldkvTEFg6gHyiRxf3w
	YRaBHjpeRKWrvDJlYR7yQ6exMKmXy3JSDZW2+P9Zlai0HbsF3TOdeX+xbKkCvSzy7CBKxJ
	tCxtKCCyuix7K03VrgngVrV16734guQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-247-2sEWge5BN8--rE-jKOcfZQ-1; Tue,
 24 Feb 2026 07:09:25 -0500
X-MC-Unique: 2sEWge5BN8--rE-jKOcfZQ-1
X-Mimecast-MFC-AGG-ID: 2sEWge5BN8--rE-jKOcfZQ_1771934963
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E2F241956067;
	Tue, 24 Feb 2026 12:09:21 +0000 (UTC)
Received: from fedora (unknown [10.44.32.38])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 2484830001BB;
	Tue, 24 Feb 2026 12:09:14 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue, 24 Feb 2026 13:09:21 +0100 (CET)
Date: Tue, 24 Feb 2026 13:09:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>, Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>, Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: Re: [PATCH v2 1/2] pid_namespace: allow opening pid_for_children
 before init was created
Message-ID: <aZ2U6TwK7rQtkTvT@redhat.com>
References: <20260223200254.4104651-1-ptikhomirov@virtuozzo.com>
 <20260223200254.4104651-2-ptikhomirov@virtuozzo.com>
MIME-Version: 1.0
In-Reply-To: <20260223200254.4104651-2-ptikhomirov@virtuozzo.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: FtsweDEL-Qlz03bh16_xZkYyMuPTA3Ezd0qHSewGpo4_1771934963
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 851F92000D
X-Stat-Signature: 4a5coupu5yaixqr73t86gi7gtpdhwf3c
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771934967-70072
X-HE-Meta: U2FsdGVkX1+Q0D0Ei+GmOESiOO2pJHWORxuMIeQu/R3+fmMUB8srbOpKjBFow7fdYOWBFkUb9iYX9qvWeuUchmhvB/mHuIQ/iegqpgypaI1YZlY+x46ibDIT9FotIY+U7K2AGTYUmA8aX1pCxPYJ7EQKSZD5BXyg777nLgh7J+eyuel+Bkn5gaXs4gzwkt+dEBx+gVqTKBR3h+zCKq8DjnSS8HgT3P1EZ1shiP72MpWJ7guDuO+sgew7W4rFoB2ee4oCjbyniLHuK4nDt7mw72gRceNwmEq3+GHXONNezgWfnMY4FWLuXTWba0v+4PqhYdqlgzKx8gF5fGz4Mlicbb9KkCTt12Jb1cMJB106pgAELZr7yX7MkZ3p3RTMThzfm/EL24GFMuoN+MVRWInEz+b0FRfdvLgbEXQh7S77B01uShat86GyrCKzeJADAvldXfxRi15y8luFOjgCP8DO59AaZffqRT+FjQwZuhNRFwHkvrD8LhL7WEsECtcyIJTxaVYoynE4xYArs1A0vsXOf9URH0Tt5v5OC7b5r7YOCWIY/tnefZzt477CLngvi1jMZJbRV/X6MIhnDKm+2jXJIQEpkX5nS3yDWj3Pcbd1agL2FFm3GjEUcZO83eCZwZYdyOC5RWHOZousCrvYulmOELFgKfftBJkCyUC9MYSws5+BfcYE8ZnNVLdX+vWwEcX8BbIjeoZOHlgOvLWmpZuuFnkvjCDCDja0MrUvIeDHBlEksEKmhhv9h4xamu/b8rgGhnJ/UbDx4jamYPrJqwfG0XFzRxi3ROV9kQtNYEeOiYpmNr7Kv7dOrred+w3VSafmdBLfePlSGTJ9j8c6Pq4iWib2MvNNFDT6iiXJn2mJy0yqfo3volJ37kk5GYnzxlGthPa6SM86TdfRCjt2TxqVoQZp5il+6vCHrpZJASsH6RlEqwmI2ltaNUJ2dDKDrcwP4fNMj00NE6Ngqs/g+HK
 T9TPk0a3
 ylpxIzCBp7cMA/fmb9ChPQDc/FrkGKevpn81Yp7drN2HQGxoeuvGC39gnCsRhB/Wn5Ca2/yx92bVH+JrNZ9nyhUbvV9Qin/ASH+6UfORbeDuTBSFH45fcuY9j7muG0lfPDC8/RTaKea2SWdOFnECtZxdfsCatXGhW9RobwCvH0hirdLKJk2QMovC3To13IajM03pAzB8nkC6KbC+V3Rv/umeAx/8Lpo68wbL/NQ4nkKhyDunEUxoF3YN6eAdiluuBWzgMMv6sVgZLcC5KvcYcxBgn85LDJllYrbY/qzCme+Cm+MfGQ7XuXBe4o4xOjNAylfFqKB2Ll/NHldVvAEkNIdR5YLbe7YOqNktdDhr0pVnysAb7bJScZcugqnjMeM2KnJ3DS0mLkeoRPLoU5rPHd3A2wg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/23, Pavel Tikhomirov wrote:
>
> To avoid possible problems related to cpu/compiler optimizations around
> ->child_reaper, let's use WRITE_ONCE (additional to task_list lock)
> everywhere we write it and use READ_ONCE everywhere we read it without
> explicit lock.

Yes, this is what I meant... but I can never recall if READ_ONCE() alone
is enough to make KCSAN happy...

I won't insist, but I think it would be better to do this in a separate
change for documenation purposes and for discussion.

> @@ -247,8 +247,9 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
>  			 * alreay in use. Return EEXIST in that case.
>  			 */
>  			if (nr == -ENOSPC)
> -
>  				nr = -EEXIST;
> +		} else if (!READ_ONCE(tmp->child_reaper) && idr_get_cursor(&tmp->idr) != 0) {
> +			nr = -EINVAL;
>  		} else {

Oh, this doesn't look clear/clean... This even looks racy even if it is not.
Can you move this check into the "else" branch which does another get_cursor
and unify this check with the RESERVED_PIDS check?

Either way, I don't like the fact we check ->child_reaper != NULL twice.
Perhaps something like the preparational patch below makes sense ? Not
sure this is actually better...

Oleg.

--- x/kernel/pid.c
+++ x/kernel/pid.c
@@ -215,12 +215,6 @@ struct pid *alloc_pid(struct pid_namespa
 			retval = -EINVAL;
 			if (tid < 1 || tid >= pid_max[ns->level - i])
 				goto out_abort;
-			/*
-			 * Also fail if a PID != 1 is requested and
-			 * no PID 1 exists.
-			 */
-			if (tid != 1 && !tmp->child_reaper)
-				goto out_abort;
 			retval = -EPERM;
 			if (!checkpoint_restore_ns_capable(tmp->user_ns))
 				goto out_abort;
@@ -299,6 +293,11 @@ struct pid *alloc_pid(struct pid_namespa
 		tmp = tmp->parent;
 		i--;
 		retried_preload = false;
+
+		if (!READ_ONCE(tmp->child_reaper) && nr != 1) {
+			retval = -EINVAL;
+			goto out_free;
+		}
 	}
 
 	/*


