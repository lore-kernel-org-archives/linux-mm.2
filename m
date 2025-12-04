Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 503C5D1D89D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 09:32:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 642E66B000E; Thu,  4 Dec 2025 04:32:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F42D6B0011; Thu,  4 Dec 2025 04:32:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E2A86B0012; Thu,  4 Dec 2025 04:32:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E8666B000E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 04:32:18 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D892C51FFE
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:32:17 +0000 (UTC)
X-FDA: 84181272714.28.40FE2F9
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id D3CC840008
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:32:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TgYp4P9A;
	spf=pass (imf11.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764840735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P9pe+wJENeZc5IcOvHk937NmwKikq+O3BvHjwpbysZ0=;
	b=SngHE9Kzz6lBx4kDN1TYsIIoYTm9hjsvJgopkjn9U/pC9RJmAna6e9HQlVN/FK1k8u/9Iy
	HT/NJP+FtFUkhNV/p8H5RX4oZS9l1XH9PHi1nziJJVtJs1yt2YbnaFf4Q9tH0wRmsZrDVs
	GKwxD+YvOpdKR2FjIQAvPMvh86Wier4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764840735; a=rsa-sha256;
	cv=none;
	b=IJd2KiqiPFAbdVbixMGAbpCQCO4JgwHIFO5Vyqyjocjezxi99cbDeeftGCyNqphtzntUZx
	uzcThIRhLZvvARRj5yR5Pk1lGKbpf6BYyBRH3cIHLtQb6WTtjnVeoLdLLRMZuOD73WiH5I
	9UlUywxUczQBia+aBQJITZGRgLmPlbQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TgYp4P9A;
	spf=pass (imf11.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-42e2e52cc04so280565f8f.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 01:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764840734; x=1765445534; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P9pe+wJENeZc5IcOvHk937NmwKikq+O3BvHjwpbysZ0=;
        b=TgYp4P9AJe6JsdsCFJmzAjhCMKOORi2ywgAcI9uEi99pK0DDhvgl9HYXoPpWR9WSPP
         rAHM9wsuTOs/p8mr/mXkbU95ddOu6aP/CEggX/5WYZnZNNjSwhAb9plgF6XiTv7MJQFF
         JjeLQ+QVjNZXiIBNJGzfgPGTlXqo0s2kNzK0AtPRjVHkukozTKQX47GWU1Swh2nmJIPR
         Ql7psZCMHH2xCz4hbJUn13HzPZlfEVAm1mgb3warpnXhdbRDs7n8JykPr0jqfsRBDRt5
         r0npqcS50EgA7/eTa/Pr1dXhTS01mwzsuSQnOv2Pt4a5umlEUAm5GXraFuRufNlPYmvT
         UmZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764840734; x=1765445534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P9pe+wJENeZc5IcOvHk937NmwKikq+O3BvHjwpbysZ0=;
        b=I19oT9/OSAVhniIDDNv64S84yMyoMzWzKPRI/p0JlZltlnpfjIz2TssJbKua7nU1Aj
         2r29VhxwXWp1yiBzo0WjkFcEB9m5wW/tPnPABxu+h1KyIGC1/GO6DJXSjyXiAkvHESXd
         CE5nZHcavLI6pDT9hZa0Hg/8/POKcI3joDlIUULowACLQQFX/9YCi1CeDFMPIiXccnDW
         CjzWxNr7Q+AG0+sN3Bps6XDpU0VP9ZFnPR+Xncbv7jIWsP168HC80tucw7GzatErqCcD
         95/lJP0vCuKU9C+GK9C/w0hKyjgYfy63qHYrd0KZ0YXhR2y9pf29sASatSJmxA0Q5rpz
         UYTw==
X-Forwarded-Encrypted: i=1; AJvYcCXYMPJdgXD/rDmrzqvzgSqPBsEFWAY2lZAzmI6CNKKLKikBZEEKlNSmBzAIAy4FnvPwvMYHPnhwZg==@kvack.org
X-Gm-Message-State: AOJu0YyLz4Jmn1mcJv0RvzaIYfWPtxRU2wpdPtNgho4W4DUBc3U2FH8l
	Yc1ZvtaOoCa3bHsYiIomJ3X7je6HRh1BNyYlAGTrqyc3xHPfDMoar3Wa
X-Gm-Gg: ASbGncsQLWl35I7r9BYiRD3doEIaWhscWrq6xtaH7bjZKiQ4l/H1t17TKQ4ouHwXmy7
	1OHBxPChglJpH5tQAdT1/LNykFoZNnSA/oJsOOQ1E3EHu3c+CzNnvNJTnyJIQQx7Ut8ImfJTSUn
	ETyMeDWOqW991BQJpPbv0Y1+fpkJy4Qn0kVeeedEfziZ+9YSIFPyjg+NNMCdJSFC7eF+bb7dlyA
	PnN77imQEvZcqvyHapwrtFtkKZjH+cOtuWBJ2IyTqg+MgVo8iy9pELJZ+md9Wnbc1w4Qnf3r3/B
	TFH7b9Hre0h9sYfB9Bk2524hvzHfBrzFK4EDlmPkBt8+SafdiI+D/LGHN/yhzhQ9xe1+aFjj4S9
	uJlfQvBiCazrSSBfITG2/7kBAqwNz3MpGxA5UcVBuWu1bkz7TjBO3N+aSXrhLattv20JzHkkTrA
	MPpudFekOuDBti3du/Ap5NI3iSWrvVpKH1UwtIaRRHhEqRdodd03H+
X-Google-Smtp-Source: AGHT+IEpeLb5DzDFyyRRjLJBycEA8/oon798RLVjm4cwDE2uj2+226ExQ98mf5m0TZ5rx0eulXU/Nw==
X-Received: by 2002:a05:6000:2dc4:b0:429:d725:4125 with SMTP id ffacd0b85a97d-42f7987519fmr2415263f8f.54.1764840733805;
        Thu, 04 Dec 2025 01:32:13 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d2226e7sm2182928f8f.27.2025.12.04.01.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 01:32:12 -0800 (PST)
Date: Thu, 4 Dec 2025 09:32:09 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Bernd Edlinger <bernd.edlinger@hotmail.de>, "Eric W. Biederman"
 <ebiederm@xmission.com>, Roberto Sassu <roberto.sassu@huaweicloud.com>,
 Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
 Kees Cook <kees@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Will
 Drewry <wad@chromium.org>, Christian Brauner <brauner@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Serge
 Hallyn <serge@hallyn.com>, James Morris <jamorris@linux.microsoft.com>,
 Randy Dunlap <rdunlap@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Yafang Shao <laoar.shao@gmail.com>, Helge Deller
 <deller@gmx.de>, Adrian Reber <areber@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>, Alexei Starovoitov
 <ast@kernel.org>, "linux-fsdevel@vger.kernel.org"
 <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, tiozhang
 <tiozhang@didiglobal.com>, Luis Chamberlain <mcgrof@kernel.org>, "Paulo
 Alcantara (SUSE)" <pc@manguebit.com>, Sergey Senozhatsky
 <senozhatsky@chromium.org>, Frederic Weisbecker <frederic@kernel.org>,
 YueHaibing <yuehaibing@huawei.com>, Paul Moore <paul@paul-moore.com>,
 Aleksa Sarai <cyphar@cyphar.com>, Stefan Roesch <shr@devkernel.io>, Chao Yu
 <chao@kernel.org>, xu xin <xu.xin16@zte.com.cn>, Jeff Layton
 <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand
 <david@redhat.com>, Dave Chinner <dchinner@redhat.com>, Shuah Khan
 <shuah@kernel.org>, Elena Reshetova <elena.reshetova@intel.com>, David
 Windsor <dwindsor@gmail.com>, Mateusz Guzik <mjguzik@gmail.com>, Ard
 Biesheuvel <ardb@kernel.org>, "Joel Fernandes (Google)"
 <joel@joelfernandes.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Hans Liljestrand <ishkamiel@gmail.com>, Penglei Jiang
 <superman.xpt@gmail.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Adrian Ratiu <adrian.ratiu@collabora.com>, Ingo Molnar <mingo@kernel.org>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>, Cyrill Gorcunov
 <gorcunov@gmail.com>, Eric Dumazet <edumazet@google.com>,
 zohar@linux.ibm.com, linux-integrity@vger.kernel.org, Ryan Lee
 <ryan.lee@canonical.com>, apparmor <apparmor@lists.ubuntu.com>
Subject: Re: Are setuid shell scripts safe? (Implied by
 security_bprm_creds_for_exec)
Message-ID: <20251204093209.706f30a6@pumpkin>
In-Reply-To: <20251204054915.GI1712166@ZenIV>
References: <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
	<GV2PPF74270EBEEE807D016A79FE7A2F463E4D6A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
	<87tsyozqdu.fsf@email.froward.int.ebiederm.org>
	<87wm3ky5n9.fsf@email.froward.int.ebiederm.org>
	<87h5uoxw06.fsf_-_@email.froward.int.ebiederm.org>
	<6dc556a0a93c18fffec71322bf97441c74b3134e.camel@huaweicloud.com>
	<87v7iqtcev.fsf_-_@email.froward.int.ebiederm.org>
	<dca0f01500f9d6705dccf3b3ef616468b1f53f57.camel@huaweicloud.com>
	<87ms42rq3t.fsf@email.froward.int.ebiederm.org>
	<GV2PPF74270EBEE90CDCD964F69E806EF58E4D9A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
	<20251204054915.GI1712166@ZenIV>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D3CC840008
X-Stat-Signature: bhbnakkgdb8uwpdxt6agbqj4xmh8kif6
X-HE-Tag: 1764840735-989662
X-HE-Meta: U2FsdGVkX1+WSju/Ei61bOPkGdzDUqgQ7HVVj3wNiEijFpZS9mJQkOQD8xULXv7Me8Xf8uoMwlhjP/PXaSdorUuBZ2uvh/PjzEaW7XI4+FpIrBsgF05UKvuo7fIAlUf5ABvZhkXMSpzekhGuNdd+wjUbsL3ZJRSwplxW2tUmnjg1wa56uOCXCcA9SpgcTq1uwWAFl4ZP9X3gitpFJKXLi507vTSq86PMKYQJzHHGKnzDrz8xx4UsZNwjl1QmOoMP8VwZMHdg/Efv/onscqDc/X+2t8p46pPIobiWeROoE02rRw+JVPj7waq0dV2uVrYpXDwEttoqsKzuJHv6GETd5IGcmNjsU72UjcyFt9j0jmEJu358LaQz17C8YBzt/riCJhRnOw2ZZar46PEVrrHhWeZ+u3UKC2oWwXsGJfK/hV+b26kHG2N9RZOT3mKQCz4ngcGoXHzIRTdV3znb/9q5RSsyi4p8Bk1+8RATqmH2RCBqL8CJvYFET93GWdY9hqAPZb0DbSVI9Sc6G3krM/wnJ6DJFx1Wf/KgubkEhLQvoYDBJ6Fi39v4yZSDiD0e0rUkdtIqlZcRUH5H1qKw3X7hOAP5ZxTjL5N87xmADaVA5r7vsWtxyBwYgHQatriMZ3UfperkoS2kgjnrjQ4YzpBXa5fVL7dA5KV7EFUVkR7GoNl/fcj8rnHfurxesyQ6DrpBFcZ9ppVH1hMaJEk1V2peQrW3FvKhQCzR6dEjOj5G+ZoA2aWzqzM+F5TpB4nXMD0J3woMvV3f2eqnMZ4m6JYmO0om0s2xTtNMG9z/JgfJ+ET8EG7TO28uLEIL3aO1uhgUmFXLAfduuNiqRR3WybybtAavm2NI9gtMLUUMW8/2wJpkakEmQz0fyFLrk9QxD/JjhnRYppuEWUgy9OeVM5Mzi43iFvQL/nSsbG4HyznBUifv5vg/WyUyND7eFDG20z9+ZEHPM+q9pKcRwSXU5+P
 kf2VGdn2
 QCu0nuSKQ0GvPZTPAoMPBKLpZei8493ae9tSgMtxE7lv6LKh+PqGf/o2jEK41XLqjHUmgXNByerdU7Q2Dxsoz/KvqkrbXhQd1igbym6nC1pluUHq4ySp4P5/asRKnwJlYG59ydwPClEoDGOA+AyncUtajU7hL2kzHOLMhyBYEBuNJL0Dqc6yF3MXf/bcHklyiw9+U+V/H+Gzl69NCKU4MMmTBsIzJsFbq9wldz5YGS/ZgI3VGbweCkflcSRiDXZ6oaLrNrdpucTFeerTODZHiy/cZTch+9nwZwdeZYrNJfy5KFRAKxhffq1sd1824eEBtnKNKnEiXA3D775dqIqe2orh3hz77hJUpcSZ9uB8Bg4fnplSFqetkWc1KdqanbdZzueIoQ8XiWZ7OzKs7TmVZ2CdXBsB4yA+OMyI/rvjxyHL3WiVb7xJjdspsRSfHVWZdewclr35vg3dH8aTJ/sEHYr6ZPOueBj1ov0ZI1kzOH96rY7aBNQnnn6d+fn3EKJ5k1gRkxPqTC4qer1Z9oF4jbsPhGYtQw7alSUqGCPo67O5HtUKXwxzcwNcWRW6jh98IG3Yo55/ELPdmcUeZqjKLBfznt/8tvsrSS7hvNx4S5+sdbF6WuzXNI922EWgvo5MnKLrV7qKU/wJzwYKHFZSQ6UbGbaJeYZr6n+/jrr0qRmSDzFRi2cV2JoWnSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Dec 2025 05:49:15 +0000
Al Viro <viro@zeniv.linux.org.uk> wrote:

> On Wed, Dec 03, 2025 at 02:16:29PM +0100, Bernd Edlinger wrote:
> 
> > Hmm, yes, that looks like an issue.
> > 
> > I would have expected the security engine to look at bprm->filenanme
> > especially in the case, when bprm->interp != bprm->filename,
> > and check that it is not a sym-link with write-access for the
> > current user and of course also that the bprm->file is not a regular file
> > which is writable by the current user, if that is the case I would have expected
> > the secuity engine to enforce non-new-privs on a SUID executable somehow.  
> 
> Check that _what_ is not a symlink?  And while we are at it, what do write
> permissions to any symlinks have to do with anything whatsoever?
> 

You'd need to check for write permissions to all the directories in the
full path of the symlink and in all the directories traversed by the symlink.
(and that may not be enough....)

Passing the shell (or whatever) /dev/fd/n doesn't seem (to me) any different
from what happens when the elf interpreter runs a suid program.
You might want to check for non-owner write permissions to the /dev/fd/n entry,
but that is true for any suid executable, not just scripts.

FWIW the SYSV shells normally set the effective uid back the real uid.
So making a script suid didn't work unless the script started "#!/bin/sh -p".
Whether that improved security (rather than being annoying) is another matter.

	David

