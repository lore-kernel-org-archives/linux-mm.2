Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7217CD216A4
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D00126B00BC; Thu,  4 Dec 2025 10:43:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD74F6B00BD; Thu,  4 Dec 2025 10:43:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEDB96B00C3; Thu,  4 Dec 2025 10:43:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AB2D26B00BC
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:43:34 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F5AD1A0281
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:43:34 +0000 (UTC)
X-FDA: 84182208348.16.28B5249
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id B557740008
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:43:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Z/DxOp2m";
	spf=pass (imf11.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764863012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xcULqT1gBZ4JnBLfYhNZO/NSXxFxQuxnawJT72KsaCg=;
	b=kZ4XPs5vesBdGrQ+CTlfWSVhKfOqc6rO+cJu2sDr6r34o2lqLxbMy5KfBZkRDOWjSo0zzH
	LWdjxc2hPldSxs3gJ9KWGU+70XTl9qLrKMOT6/4RCtGzJ/qI3+u9lVP3Srn2N8+pT9dv+6
	SJlxySDwrDn9bCsxoHgu5HbC8Ik66R0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764863012; a=rsa-sha256;
	cv=none;
	b=EtssmAQtsaoC6HdoykpZfoVRnVE8VEu/3r+hMENg1mAfCdMV6Je8VRyPHPCTuYhnvrVBNY
	m2qVjR/KEo1Yv7z/Qrg2vRN2LrrYF2/oyHfdcm4P1IHFyaV/7mmhLH6X1ZdXMCViWFHkz3
	CVAfw2nn7GeC+jbe+dclmuNe7istH3g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Z/DxOp2m";
	spf=pass (imf11.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-341988c720aso844518a91.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764863011; x=1765467811; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xcULqT1gBZ4JnBLfYhNZO/NSXxFxQuxnawJT72KsaCg=;
        b=Z/DxOp2mrHgLlEsckTXKcAAcfI+Viq3q0JTGmCcwPjPTgIZSyfOZzxeIbrvMS8c4fA
         ARBkiqWAHg+6y3ExgHj1/ib6nGEFB22Gv/O3vf5A+tbYTNiPDKedWjL2sFovBfltjYqH
         b+zIJjk0PvZaemvmPOJF/qnMikNzvoOUl4dBWlgjtIT4JraBnIdmEptkiNeChcF/VVxC
         WFhx9ZOR1M6Dn6CigwQhQAeipt7PXr15/tq5x8f2C0ECS5LQ+qLYxtCoQ5O5W8mtWi+F
         kM8G8WYZL78X6lzUTAYLRvlHaq6UaCxy+V/yvRKxklikxTeO14W/cvMzYBKk3hTDQpOv
         +Iwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764863011; x=1765467811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xcULqT1gBZ4JnBLfYhNZO/NSXxFxQuxnawJT72KsaCg=;
        b=axAKtNJ4Jlh014zHpcEPiA7z1zt21Z1kDF7U7nXjPLyug6p8/UikgW39osF0GEW41+
         2waAEQfDh5hGiRxwZ8ziQ+3lBrLLBn3D8/Ev5IWu2E+DHczqULCS9eZqJrfBYRwDTUY+
         je6dLe6J9FW+hsf6IW5NFigA0mW6P2xjvdKJt0EdSC+9ddtqDkrAtBoTdBBiiT4yotii
         nTgpbDMLDaWJWNiJwgS8m5mlvVdtKkeqxK96y1zc5+R5SmXSyFn7M6gXocZVkjmH/gxa
         Au/xP1CRpkTQGr+HmyZ4miNHfwaxYu0Qdl+gK4ZjNAUVp77ephXF+V6gJmUqgAc6tj/x
         iJOw==
X-Forwarded-Encrypted: i=1; AJvYcCWq4Ho9iLG+isNqcvOLSsYhSJFJNyc6lesBLCfVk603r6JDTrOuiXz6qD1k+mONEKCQhjMMvn9DAA==@kvack.org
X-Gm-Message-State: AOJu0Yzc9QESsqYWSjReFAi+gS/kne0eKTjTS9X9QAGbACbchDed5j6G
	gQ0ucW4y+H7F2Xcqv3mYNfqG5iBpn9IVusqOpRFEZJppLgJ/ed+bSHvkmIqGSYn5uO1PoBDjfT/
	JMRNXnAqYYXPoQzb3hln713E6GR+mDg0=
X-Gm-Gg: ASbGncvx7Kxh4cEKvDUKpycFezEfcrlc1KAjFQg8ogJu2GZScsK68rSHbzwtD/a8yvw
	E3EZukbO2UDyh/gjI6uNcTfvhNXMudUssiNh3Tj46TcA/fMTWNl/OwCPP53rsD9/neuBOW1yOMb
	nZA4BX9AP07gbYDV1+Er34TGaNRUaVdK+LdzWXd2BbJLH2IwE1lCszSuIuwTc2qFxAlto9QJH2I
	3G6mASYJmeHWivBHmORONjR0u77z5+NHplpfcu3gUzUIHtg0CA80QKp2it5m0wyRyDKkADMVLup
	vamN/A==
X-Google-Smtp-Source: AGHT+IGPP0xbr8ijlvBCGceLouNPETyq6yt+2wUuDhEptf1TXNXkd61Kk0839gQ/19JRkHkqwlnGsXbepfF7hCbJxRQ=
X-Received: by 2002:a17:90a:c883:b0:33b:d74b:179 with SMTP id
 98e67ed59e1d1-349126e0e1cmr7801599a91.27.1764863011360; Thu, 04 Dec 2025
 07:43:31 -0800 (PST)
MIME-Version: 1.0
References: <AM8PR10MB470801D01A0CF24BC32C25E7E40E9@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AM8PR10MB470875B22B4C08BEAEC3F77FE4169@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AS8P193MB1285DF698D7524EDE22ABFA1E4A1A@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEE807D016A79FE7A2F463E4D6A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <87tsyozqdu.fsf@email.froward.int.ebiederm.org> <87wm3ky5n9.fsf@email.froward.int.ebiederm.org>
 <87h5uoxw06.fsf_-_@email.froward.int.ebiederm.org> <6dc556a0a93c18fffec71322bf97441c74b3134e.camel@huaweicloud.com>
 <87v7iqtcev.fsf_-_@email.froward.int.ebiederm.org>
In-Reply-To: <87v7iqtcev.fsf_-_@email.froward.int.ebiederm.org>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Thu, 4 Dec 2025 10:43:20 -0500
X-Gm-Features: AWmQ_bmUfrO0mY15dNq3SP9hR0Gn5EatRKdJVj7voKpq3-tHkT_aD9YVC4fN8UE
Message-ID: <CAEjxPJ61OHDxmc2fgBp=hq27OoEhkO+Wwbb+rYAf2F9fM7gdLg@mail.gmail.com>
Subject: Re: Are setuid shell scripts safe? (Implied by security_bprm_creds_for_exec)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roberto Sassu <roberto.sassu@huaweicloud.com>, 
	Bernd Edlinger <bernd.edlinger@hotmail.de>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees@kernel.org>, 
	Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, 
	Christian Brauner <brauner@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, Serge Hallyn <serge@hallyn.com>, 
	James Morris <jamorris@linux.microsoft.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Suren Baghdasaryan <surenb@google.com>, Yafang Shao <laoar.shao@gmail.com>, Helge Deller <deller@gmx.de>, 
	Adrian Reber <areber@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>, 
	Alexei Starovoitov <ast@kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	tiozhang <tiozhang@didiglobal.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Frederic Weisbecker <frederic@kernel.org>, YueHaibing <yuehaibing@huawei.com>, 
	Paul Moore <paul@paul-moore.com>, Aleksa Sarai <cyphar@cyphar.com>, 
	Stefan Roesch <shr@devkernel.io>, Chao Yu <chao@kernel.org>, xu xin <xu.xin16@zte.com.cn>, 
	Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@redhat.com>, 
	Dave Chinner <dchinner@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Elena Reshetova <elena.reshetova@intel.com>, David Windsor <dwindsor@gmail.com>, 
	Mateusz Guzik <mjguzik@gmail.com>, Ard Biesheuvel <ardb@kernel.org>, 
	"Joel Fernandes (Google)" <joel@joelfernandes.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Hans Liljestrand <ishkamiel@gmail.com>, Penglei Jiang <superman.xpt@gmail.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Adrian Ratiu <adrian.ratiu@collabora.com>, 
	Ingo Molnar <mingo@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, 
	Cyrill Gorcunov <gorcunov@gmail.com>, Eric Dumazet <edumazet@google.com>, zohar@linux.ibm.com, 
	linux-integrity@vger.kernel.org, Ryan Lee <ryan.lee@canonical.com>, 
	apparmor <apparmor@lists.ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B557740008
X-Stat-Signature: s35c3cncfagnfxxdfog5wh7533b9z7xu
X-Rspam-User: 
X-HE-Tag: 1764863012-750821
X-HE-Meta: U2FsdGVkX1/6JUmp7OPJHhoDSqba4Jj52FLxnHOL9iIFNKKSYGaqcIdGE6Zn9sWBwspbHcUkTZxov5tdRSdH9pVipm4Hc//BlnY2qs9nxBxxEP5G2/QL3gwPWNmnZoA9zstJsimcOyOrHKtrcedMeIQd7Ol/+I8aMlEPz8HwxkvOEQup/hs6qktAAWysoZn3GyjYyb9fplUH0dGwb5+SwQXlc6awWXAbjRi6GryiQaW/FHdGOU8HVXwiVyzBWey6u6qmwvT/symmlReBzq80kiqNKx8pySkG2Z0XRR/DqHNui3o1wEr4aCvoR4ViqszyzkWZRrcTcQztXG3DZtlAw7xeniPFf/C7YgyAIfFLpRmVsqM24/wCspWXjM3XdGUb4j5zf0Cz4xTKH9VPC0L5i7fEMPOMIjRSRvLMfTu9/8OXl/f9kfFdjFj7dCBwetbjVgmqQeGz2IVARE2tVjOVBfmucb5O1Ao0SLrB3UopkhSfjPqdjbMoz3Z8916z+ISercPAdU/xA+D7d1SDcWvhcNtkPU6g4fk4Vmyy4GOtkLODptOe0O3GQ4KSDgPwA1ls+522fLzq4VrVrZbkbRXSxNyDpWLBvVUiHtTEk/Oz8eyzoxKgyhgf4E7sk5zJRPV/uI+iV6nzrte7IajgBR3U4/1NnlXNAL6Bdqj3oWHy6hhymtkfG7kvlKR1k6Q9BTau51X5E+DPgBt64bSUkjqt+6DIShxdZb+f67trUnHDpyprzQQgsYLegoTj/yKXjRUuXudCE/G01CKGfA88MqffcSGFRf87gVmzAqdKgHSVzMVVmBFtoH2TCznF5oNnlVbwAvIP0zVSVmo6XG1Qfm5g9oxatCKyOfMjwg7Iq8vbR9QbfKDmQJ7YclXPejDdtYl0u1hOIXxUH0yea9OF/k2LiuoH3ygZT4Whz3IaUU+Hf2ztrgOfQyv9o33QBFrMncqhrkcTk24sV4vVa30Aub7
 vo5QUZto
 3CsJW5UzellqpE8xXbFEcdiutzRjkYVYWDDCggnS7QdTdW/H1Ua/dBkeQdAVZtEX2O0orEg2M2k2nZZVCrLjUGVA9hzQNhDQV6jAIlpZNUtkFNOtevi5L9cnsL6a+UmI5V1zybp428UWffpusPMvajgDaudDEGAO3d2alGrGnrSNF9txUexiWyXFxwivZFeeyM+1uqnuOgYapYBqMuLVMu2Lz59KG8S07AuizJ1WpLpZItDxr3NLsZVmXlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 1, 2025 at 11:34=E2=80=AFAM Eric W. Biederman <ebiederm@xmissio=
n.com> wrote:
>
> Roberto Sassu <roberto.sassu@huaweicloud.com> writes:
>
> > + Mimi, linux-integrity (would be nice if we are in CC when linux-
> > security-module is in CC).
> >
> > Apologies for not answering earlier, it seems I don't receive the
> > emails from the linux-security-module mailing list (thanks Serge for
> > letting me know!).
> >
> > I see two main effects of this patch. First, the bprm_check_security
> > hook implementations will not see bprm->cred populated. That was a
> > problem before we made this patch:
> >
> > https://patchew.org/linux/20251008113503.2433343-1-roberto.sassu@huawei=
cloud.com/
>
> Thanks, that is definitely needed.
>
> Does calling process_measurement(CREDS_CHECK) on only the final file
> pass review?  Do you know of any cases where that will break things?
>
> As it stands I don't think it should be assumed that any LSM has
> computed it's final creds until bprm_creds_from_file.  Not just the
> uid and gid.
>
> If the patch you posted for review works that helps sort that mess out.
>
> > to work around the problem of not calculating the final DAC credentials
> > early enough (well, we actually had to change our CREDS_CHECK hook
> > behavior).
> >
> > The second, I could not check. If I remember well, unlike the
> > capability LSM, SELinux/Apparmor/SMACK calculate the final credentials
> > based on the first file being executed (thus the script, not the
> > interpreter). Is this patch keeping the same behavior despite preparing
> > the credentials when the final binary is found?
>
> The patch I posted was.
>
> My brain is still reeling from the realization that our security modules
> have the implicit assumption that it is safe to calculate their security
> information from shell scripts.
>
> In the first half of the 90's I remember there was lots of effort to try
> and make setuid shell scripts and setuid perl scripts work, and the
> final conclusion was it was a lost cause.
>
> Now I look at security_bprm_creds_for_exec and security_bprm_check which
> both have the implicit assumption that it is indeed safe to compute the
> credentials from a shell script.
>
> When passing a file descriptor to execat we have
> BINPRM_FLAGS_PATH_INACCESSIBLE and use /dev/fd/NNN as the filename
> which reduces some of the races.
>
> However when just plain executing a shell script we pass the filename of
> the shell script as a command line argument, and expect the shell to
> open the filename again.  This has been a time of check to time of use
> race for decades, and one of the reasons we don't have setuid shell
> scripts.
>
> Yet the IMA implementation (without the above mentioned patch) assumes
> the final creds will be calculated before security_bprm_check is called,
> and security_bprm_creds_for_exec busily calculate the final creds.
>
> For some of the security modules I believe anyone can set any label they
> want on a file and they remain secure (At which point I don't understand
> the point of having labels on files).  I don't believe that is the case
> for selinux, or in general.
>
> So just to remove the TOCTOU race the security_bprm_creds_for_exec
> and security_bprm_check hooks need to be removed, after moving their
> code into something like security_bprm_creds_from_file.
>
> Or am I missing something and even with the TOCTOU race are setuid shell
> scripts somehow safe now?

setuid shell scripts are not safe. But SELinux (and likely AppArmor
and others) have long relied on the ability to transition on shell
scripts to _shed_ permissions. That's a matter of writing your policy
sensibly.
Changing it would break existing userspace and policies.

