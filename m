Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE9DAC982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 16:38:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E3536B0088; Sat, 19 Sep 2026 12:38:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6948D6B008A; Sat, 19 Sep 2026 12:38:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AAD66B008C; Sat, 19 Sep 2026 12:38:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E29D86B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 12:38:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13DF2C02D9
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 16:38:26 +0000 (UTC)
X-FDA: 85231069812.08.1E99E01
Received: from mail-ed2-f35.google.com (mail-ed2-f35.google.com [74.125.228.99])
	by imf29.hostedemail.com (Postfix) with ESMTP id DEBB5120004
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 16:38:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=NYM9ClvQ;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of torvalds@linuxfoundation.org designates 74.125.228.99 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789835904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGWocLshUzVVG8Rydp43t4CQtO4FrerHAEoPSMI/C8I=;
	b=LuY+nR01b8VkknRSi5AUtjAU/8N84mCqe6gR0daIT/qSyxhBBv5vnfqSGzKAkSyz6TlCG+
	MgFIPj32qqw/6pLPa8K1CaOm2EsuYd6Om9tU6T2SPPl2RwB9GGBUJae5c5TjfiQdLP18o6
	Yx9mVw6dVX8WkALwqPDSyKljc60kzzc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789835904;
	b=QnVgws8KZAPqR33w3aLICgqsBr6lgVTMMAvJzyL3p/eGsG8diKCFz3fqK+MQsIJJV/3zqG
	wLmsVIbN4Qxow9azPqhVIOQZ4mxNAR0lDSzFDBo7Ks4xZ8jgYJMoSe+sJI0CxvpvAL2Vou
	mnNpqIyyWgdohsboW3PGsPv9mTc4gac=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=NYM9ClvQ;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of torvalds@linuxfoundation.org designates 74.125.228.99 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6aa053900f5so2981199a12.1
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 09:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1789835902; x=1790440702; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UGWocLshUzVVG8Rydp43t4CQtO4FrerHAEoPSMI/C8I=;
        b=NYM9ClvQ4WohktOBzYWzwmjuYZd8bTQYJKUdY0cesXSMAuTLMPZ2yT18N6oDabqyAL
         5ZD/kGb5TH9Iom9j1kMxteHvaqJwmw5GSI0piZ9VY7evEBNzORZHqVyzfQM1oLPm5+qy
         0jEVjloKP0w+QYNR7Crk4H5ZsDSGl8ouoghLU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789835902; x=1790440702;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UGWocLshUzVVG8Rydp43t4CQtO4FrerHAEoPSMI/C8I=;
        b=OnpiN34u9LN1Lfz3X56MfPKQx6Dno8isgUbz/JQHEC11+DNDeIhG1UOJwe9fPRqyQH
         +OPhzFJ1y7NMxpRC6ebwuo2hff2Oc6px4ZEYNmItVPi9u85q3kn2gIREIK2HsP8NUN3a
         PWYuhOgSe6sCsn0zagIv2Iy2kd+0RpsQUKGYW10Xq/0sxMTK3N6A9gCvb+T94hdfKgt+
         380CBb+SUwX7h9zFZSByMhh8rLNBFAjSW/b7TueSIH7Kw1jFZUj9ow5KTrgYY7DVx7rx
         ciFwbbIS3A2gb6/asdPo9GpTg2w6mMl6c5qBE8PDBm6O0aQEv/LyN/5ct7cGRSUHV6W/
         HmOw==
X-Forwarded-Encrypted: i=1; AKwUvBxvSQEoSZ/e3OEDiMYWC6eyIWZ8Vmge+Oes+p0+/oEropGQvpFB8MQBtPG6K5dyzaxz0C5H1/K7TQ==@kvack.org
X-Gm-Message-State: AFuF++kQ+H1UF6hDo6aowylL1glYm49WG40GkS8Tf54w+g40UMML0gVJ
	XUzZR6TTsyeAArDRbCP0CqYtza+ElYoLSvuyxr9+WKmJURIxkXObELyyHwaYF4PPUUbjPOHURIN
	oDLWweVA=
X-Gm-Gg: AYBFou2VlA/KdPZ4lDCgvoPdrrHLwciU27xlmtqtyowjAg0ZlUoToGT27o6uHDBYltx
	/E3eeF88ynNDEsPc9j38d5iY/ajw4LUSxk9xXFjXqszNosU3NnGRIiXuh4wBkQTK+WC4uLmc7LG
	cfG1QCGqecsSfXm3PoSiU1OrwNO5cK9UY6JAJhwC+8/23vlmy4xco+KgQGgb10NUMe+lmHghcJA
	gEjlg/H08r/bC8+iv05V5JuaO/gI/G3bpB9RgmnhjEpHM+PGr17yu/TqmG/Q1RK0WAkmp8pHMhO
	Ts7L6ug1+FgM9ATUINq70sduCKUqXfFUC/hs7BITnIm4qAgOzUxuA0ecwY0Ox/OroYNxlu+SBCL
	EANkfFMizfL9OEPE88wDEMTorIEcaYOhsjTaEyk6MY7gFhl2Zoi4Hc/Potsol0Zs4xezHkG9W5n
	dzXweaZtZG1SVJrtPMtOG3ymsAVMa8PXBVUpzFyaNJhQvO3Bw+aSd2+Sv1BWbIwTo2WSIolQ3z/
	YI3yXAJpYHixaGpANLbkoBZxJZM1xvnyiHilFct+o+jkFOAAg==
X-Received: by 2002:a05:6402:46cb:b0:6aa:7fb:7678 with SMTP id 4fb4d7f45d1cf-6aa576eb7fbmr4047057a12.6.1789835902052;
        Sat, 19 Sep 2026 09:38:22 -0700 (PDT)
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com. [74.125.228.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aa67e35d64sm1485086a12.30.2026.09.19.09.38.21
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2026 09:38:21 -0700 (PDT)
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254fa4c24cso277779466b.2
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 09:38:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw7JtgXIMFx5KeIg1PjItVJBjzpARBRraPY0vk77+6Ao1elnUH2APw0wTyprku6I7RP3E6HcaUgKg==@kvack.org
X-Received: by 2002:a17:907:6d0b:b0:c29:2646:fc3c with SMTP id
 a640c23a62f3a-c2a158569e3mr548265666b.15.1789835444190; Sat, 19 Sep 2026
 09:30:44 -0700 (PDT)
MIME-Version: 1.0
References: <e9669b34-12c2-4cf2-a887-315f581f0789@paulmck-laptop> <20260919000056.3132131-1-paulmck@kernel.org>
In-Reply-To: <20260919000056.3132131-1-paulmck@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 19 Sep 2026 09:30:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj9knmxXD01=top1DQ9_aqrN2a3kpWRS5DQv6QLwLOztg@mail.gmail.com>
X-Gm-Features: AcwNN1UfxSUGwclkVhiP1abbV-DjzJIO2ybg4zteTUzmnNfVhojty9fZ436aqK4
Message-ID: <CAHk-=wj9knmxXD01=top1DQ9_aqrN2a3kpWRS5DQv6QLwLOztg@mail.gmail.com>
Subject: Re: [PATCH 01/28] hazptr: Implement Hazard Pointers
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: rcu@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Boqun Feng <boqun@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, lkmm@lists.linux.dev, Zqiang <qiang.zhang@linux.dev>, 
	Wang Lian <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
	Bradley Morgan <brads@mainlining.org>, Nicholas Piggin <npiggin@gmail.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, 
	John Stultz <jstultz@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Joel Fernandes <joel@joelfernandes.org>, 
	Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>, 
	Ingo Molnar <mingo@redhat.com>, Waiman Long <longman@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Vlastimil Babka <vbabka@suse.cz>, maged.michael@gmail.com, Mateusz Guzik <mjguzik@gmail.com>, 
	Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DEBB5120004
X-Stat-Signature: 94hm8axom3t3ryqxuqmbbpxc69saebkt
X-HE-Tag: 1789835903-457568
X-HE-Meta: U2FsdGVkX1+NA7e7nBDZ8LOVQ89G14WRp1krff7O+EeU8BMMXdUx/5oT3cWKsqxwD+Hhh8TbZDjKSOE8nykwePjivoDRAy5Oh49Kxb7QCN6fHkQ1EZeYZ/gqYdZynrj4inUvipsAxzIUjhQJIsYgsOYW4xCrUuFHMQD5jgwQ/VrbvDTgw6ILThLIwCNqytcInC1fhXUhcdxBMhdlYDzPBX0te6F9MgZI6O6HKX47mRxTgvLA8Q/stXazWO3OnC2tOY3zwKSaOodmgXLMihhfyUK9MuXZJVqbzCrInjMfmAQmQ3d2L1B9w/sHBsZLOblENbaxLjyE69jDChohotFDxHQIiuiFOAczZrL5dqBV3eSVqYDUvXs98CLqw8lSs+UpTjU2P+YW/wMKyvSOrwzxu4WoSK4/W+dlAYJ5YjxFFtHjH2Vv/4UXdkrVf28FTMr62u7iVkLfkE0sfwez0LFBwePXonB5Ect1Z3G2PlGcNr0DizS50ePrvYJkxciWXyi49KIeEle0wj5PY+UwwfroZ6zo1+oBrG1sMebIj57vApFWGMAnq4RLhYkEPGNlbwjhreVOLC6SQ4jU2hXizWjZWrEqaHOEwUusX3n1io71wr8dTs6yeTJTWtW7mER3QeXIrkDpC52rNtppWd5CvvuEPRlzDhMu3nC5LnIbeQ+yB/IVEolxdOJFCmllteZfLx6rmxAqXrdoVRw1K2r1rxCUur2X2VtGsSAOayyW13qD7UTs+1/xadrhw4d0YbJOBD20ciZuRmJQ1FTo49sSR/Y7TnDX88RekflsWl5gsjVOQ2Jndt70RqsStQlOOmLkWI69KKSxEXRdAe5HlQaOXvBxFNpLt6TLPttueP/QAEfhGbJoAxXs2i/E2RWpoKFZySUaGre8ZaAxX8idS3b9j1jZhTIbguLUW9/0bHMWFexKXzSv/dMquyoNbLbnIbzhsAoERsk3kAL0K218BAxQNM6
 0kkQirGV
 SY4t1tf4LknG63CxUEqCrHapgRQMPebNaBW5rvDB4FWQypwN2uZH/MZnfvZpuzSGBMLNsGnNWaKEXHV0rY+JejPLkNkLOjYDlOalRZsl6J+ZSff28Ei097F9GbMytdKJmtRJe4/fSZBOhAsG23n+OLq5yBzjb6r0mwSkXL6p/5m+V8HuNTjAzv6nICgeI01mLcF3JpzvnRvHSNPtxVxqDzBajnvT+pr7RpBTA2YOmO3mGtRFkThwM8QyiNQDHcKqj8sXNnRIBHFeTptkRT5c1ovTZTYDA0d8NZgYx/k+WbJNBhvmZEY2/dF6ZsBJ1H9rUUIdMRtfrHF3rO5XarceKTe689dYOiWjE2o1HGxLStckgekcN9fYtVgELGWA2+C0R3zh3JPNz5anPPv9cmGvUyx/VJMoZgLDr2rppQJb4DYG5ntsbnLU1fqI0+gUNc+p52AVc0g5phR557uvOO+z/m9FV99tk3PaAUYUSPwAukNf4Y8JDnCvn6ETbCulvZF+6+n6PcBwr81OopznYD57OmuHDzBfcN1owhuSiRuiI7Qmd+67Co3zLdAX17s3eSBYdoFOKgfhtL1US56zQoi/x2ULXXwcKvy2jNDoO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sept 2026 at 17:01, Paul E. McKenney <paulmck@kernel.org> wrote:
>
> Its main benefit over RCU is that it allows fast reclaim of
> HP-protected pointers without needing to wait for a grace period.

So last time I looked at this was some time ago, but the thing I was
missing then seems to still be missing: actual real numbers.

And no, I most *definitely* do not mean the pointless "do this in a tight loop".

That's just garbage. Honestly, when I see those numbers it just makes
me go "I don't want to merge things that even mention this kind of
stupid load". It's worse than irrelevant - it's an actively
misleading.

So I want to see a real load where this is actually visible not a
"loop a billion times on a hot-cache thing that doesn't do anything".

               Linus

