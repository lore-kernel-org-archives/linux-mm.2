Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2B06E66891
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 20:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52CA96B00A0; Fri, 19 Dec 2025 15:57:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 500F26B00A6; Fri, 19 Dec 2025 15:57:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424696B00A7; Fri, 19 Dec 2025 15:57:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2CCF86B00A0
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:57:18 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD55E8983C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:57:17 +0000 (UTC)
X-FDA: 84237430914.04.D0EFA2F
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	by imf25.hostedemail.com (Postfix) with ESMTP id CFA95A000E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:57:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=42advhE8;
	spf=pass (imf25.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766177836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4FWBwq5pA2UdoaEgzi2KEETeO4vK6VBDGoxeKhWq2EE=;
	b=ekDagj/e5d818BYAza3j03nVZE/jFchLG5X3lGSuihNrGAcdeMnJaxBFAYaahP51QmTGLt
	1FmpPZB0JO4hFRKRAzghgJdqI0AHeZ+G09NlBsZ2sD2KNzpTOWVw/3rIHSW0/JU72ixGnw
	srvcFH5bdx95dFLXHFvWZhm3otnc5GU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=42advhE8;
	spf=pass (imf25.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766177836; a=rsa-sha256;
	cv=none;
	b=J1JvoTfLT41PlBKIg5Et64fMclL56cW1DduCvKNZ4Wwd+j01rzKgD87y52ZTIaMKUZ7I9N
	5mrXUG0f+AaCr82DFAuacAO4cq6PkX7uKTyPLss9sYYY1l3lqqjJcqKI0heNDv1I7+og3A
	EtGZi+QLA/ABdcVdn51EjYbiGRAtfYw=
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dY0GL6DqzzlwqQK;
	Fri, 19 Dec 2025 20:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1766177827; x=1768769828; bh=4FWBwq5pA2UdoaEgzi2KEETe
	O4vK6VBDGoxeKhWq2EE=; b=42advhE8BUZnyv/5oJUUeZfNT/pyn/krhapzDFZR
	OBUJ0SwyUsXO7uWfZ6iD0TrvIUO0ufVYHcs9gPs9Yqxc4qotWvsEzwGramYp6CYN
	o+EGCohH3V8J9IhuomIk/LCHjW3RgZPH2dV8y8Y9/buyyKUpXBWBMrItfx8AOqTX
	jq7pYXvADCFY2Cl8TGfhSzpmEiMCCTvc43oPwpNA7c+USkz6m87eVaXEmQbE1pLZ
	puRIt1KDSkfXRrJ6t868WlCL5q0CmJX9IeVQSPmC/fOCbhWY/f8+bgPqRX1GSUKF
	gqoq4DJuwCbsLvpoRdEwWeEfLonpdDECo4UR7y1nVmqsyg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cbXucOoI7gI2; Fri, 19 Dec 2025 20:57:07 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dY0Fy2c2mzlwqPy;
	Fri, 19 Dec 2025 20:56:53 +0000 (UTC)
Message-ID: <4d6ba8aa-cc33-42a5-ae28-7a480d660c45@acm.org>
Date: Fri, 19 Dec 2025 12:56:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 18/36] locking/local_lock: Include missing headers
To: Marco Elver <elver@google.com>, Peter Zijlstra <peterz@infradead.org>,
 Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
 Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
 Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>,
 Eric Dumazet <edumazet@google.com>, Frederic Weisbecker
 <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>,
 Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>,
 Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Josh Triplett <josh@joshtriplett.org>, Justin Stitt
 <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
 Kentaro Takeda <takedakn@nttdata.co.jp>,
 Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland
 <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
 Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>,
 kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org,
 linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-19-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251219154418.3592607-19-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: i7oe889b99d78s6q6r44y6bpx6jot6fq
X-Rspam-User: 
X-Rspamd-Queue-Id: CFA95A000E
X-HE-Tag: 1766177835-597204
X-HE-Meta: U2FsdGVkX1+6dz3S//npUOIzE7KVw9YHM+x7Oha+FJuO4mM/AYkrGSEbG5mGbQcb02kylN+nSl9Fpb+pZ8d8xINVanjl1DTPtVQsnz5SnA9xT11qzXjGnRzhVWxs+ksTdMqpPa7Jf4DJUU2QX48TM5bHhS8SC2O9aGVB3OMNWOKPAv7hVhXDe6fXnpCpSUvKQ3YmgyvLa4xW720hi2szxsSLVquBZutPBeBtidJJspfqbCnYqsqAUZlvQpIMjJHOIU9agLO2JrO5x6Igj/fdB37NV94tt8wPX2Q9T0LngrADjn4KoS3IC5pHE56gy/YiDhHXPM8ic7JKu+jtuCTgSNp0WXDObkKVoF4U0H1n8LtvGZeSd1SjdtbUQoHPu3ArTOV2RsKjS2E1LJahX+7E4gmIgLNxLunS/fKC4L05cJ2RdGluu1T68lE3V/QeykXWiE6SA1atGRCxqZgUwQbI0jgoYQSMi1bIebfIcTGpCXx4kVgN6I2WAWhTi64hS7yTEDE/rlOhRkpcMmLonPEm1lKijA3BwpVeSYlN7aSMPlYaIV7YD6fmvzYgBFZVNIRphMrrNSXv46GhCdD90cmvI8qam/du+sAzsJGixo1954bh+pathZRwjM2PaJXjeZNyY6hrPz4gt5RwlsiOxqnE2WXfzb/iuRRLGN0icEIG1WR8gjfgCy6gVTsprGxKkxw42sHuiR/oYKhD78E+d30uJeI0jQWwZ0sPDqJYx4X8MT2gOeinfGvgFII2+6rVGZ3u2FZ+UV1gPTv5C1Zd1vRn6GLGMoeig4UKSGQGceCIBJOI8tojyDYGCIi6J9f1L9J9wos3EMqUt+x3gPEbeNZGWf58pnwuNueWkGXeNHvDSTfPGTi/mq86SLER0rYv0vgOQCTA9ql+Kal7nFnETHwBr0g6ZzQJq5ff/Gshl5vdsX+WNLqvOG8u8jlMMB+zl41XpjN01Y/08Q1k4a2vMJO
 VMQuT6ab
 KhMdard36MTRR3EflGt6VOv04ld8QC3BL/KHTcncUyqj8uqpvQtTvzPxInsRrolIJH2iXNnFoPzwGXnnbQsINZbRShVB+QLNlhrxTwJkD12BwqfniNAPbtcggvYVje3J4p4CcYepCPgl/mPPp76L+YGvODWq7Rl+tzprQD+kCfzL9HhvauhQfvlVajeRVSBDCEW7l50iTbW5ub3Yh1SDmaf98v0HOM5RsDCLO5K56sWDMjI91tB/1LiH4UCAfKje1IBvIExqYbSdxDanMH8oXNEBwcizbGWeGsQtIWpxn0K4Usol6GO2lBtBUR46nq6Cud8Qt2Ul0DARskSFAdMce5SCTUiFB2mu2U7vfvJxbPRph305ybmawsq7iD12rPoAGHFmd7vVXYL8mnKB30GefIxZI5ue4e64bqnAvNufamd99H58Skzd0QW2FxnL94HgVbEK8rsXRbF5uzN3/oV8SkmsZmIVTTNbpvW3v0kbRWpkTctaGcV4d+IzLcNXc/qqU2RRq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 7:40 AM, Marco Elver wrote:
> Including <linux/local_lock.h> into an empty TU will result in the
> compiler complaining:
>=20
> ./include/linux/local_lock.h: In function =E2=80=98class_local_lock_irq=
save_constructor=E2=80=99:
> ./include/linux/local_lock_internal.h:95:17: error: implicit declaratio=
n of function =E2=80=98local_irq_save=E2=80=99; <...>
>     95 |                 local_irq_save(flags);                        =
  \
>        |                 ^~~~~~~~~~~~~~
>=20
> As well as (some architectures only, such as 'sh'):
>=20
> ./include/linux/local_lock_internal.h: In function =E2=80=98local_lock_=
acquire=E2=80=99:
> ./include/linux/local_lock_internal.h:33:20: error: =E2=80=98current=E2=
=80=99 undeclared (first use in this function)
>     33 |         l->owner =3D current;
>=20
> Include missing headers to allow including local_lock.h where the
> required headers are not otherwise included.
>=20
> Signed-off-by: Marco Elver <elver@google.com>
> ---
>   include/linux/local_lock_internal.h | 2 ++
>   1 file changed, 2 insertions(+)
>=20
> diff --git a/include/linux/local_lock_internal.h b/include/linux/local_=
lock_internal.h
> index 8f82b4eb542f..1a1ea1232add 100644
> --- a/include/linux/local_lock_internal.h
> +++ b/include/linux/local_lock_internal.h
> @@ -4,7 +4,9 @@
>   #endif
>  =20
>   #include <linux/percpu-defs.h>
> +#include <linux/irqflags.h>
>   #include <linux/lockdep.h>
> +#include <asm/current.h>
>  =20
>   #ifndef CONFIG_PREEMPT_RT
>  =20

The abbreviation "TU" is uncommon. Hence, please expand that
abbreviation. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

