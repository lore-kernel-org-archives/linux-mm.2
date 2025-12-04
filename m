Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BAF6D2A54D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 21:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 616D56B00B8; Thu,  4 Dec 2025 16:39:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C77C6B00BB; Thu,  4 Dec 2025 16:39:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7166B00BE; Thu,  4 Dec 2025 16:39:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 35D576B00B8
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 16:39:03 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1AF5884D9
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 21:39:02 +0000 (UTC)
X-FDA: 84183104124.12.7880F54
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id BDDFC1A000F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 21:39:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WO2o2TCq;
	spf=pass (imf19.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764884340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7a4apymdvLMzvSssxC4jYelA1RIA+3s9lZemZv4hiVM=;
	b=5jJ0KskZNfeG0RoX10geZ5mWYQ2PZkdx0BNBnpJg8lHaBW1ldrvEhWW9uUjIAonr33YM7B
	/DI3lIW3o4aXFRa+yONlsM7QgX2mZduiiV896KhtkkJCxkBiHb0kZh0gA57iHA4Xvi1/pz
	hrTcQV9AXcjXjuhVhyPD2M0yeIZdSK0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764884340; a=rsa-sha256;
	cv=none;
	b=QeU1ykV03GGnERGvEkxWpnYXkWl1gGzuIkPP6aFbFPBLcZ6Hh0ZuYDqf4/7Z17Coegxs24
	G07BzFSSocWi0VxCp2uvi4m8wdhaL5EVrQZ5G7GUNKUf4EtUhiCatdKHlHgWg54b9BYbfJ
	W6tjDotoNoP6eaCG+ZEZwGP00Dr+s7g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WO2o2TCq;
	spf=pass (imf19.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7aab7623f42so1645523b3a.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 13:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764884340; x=1765489140; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7a4apymdvLMzvSssxC4jYelA1RIA+3s9lZemZv4hiVM=;
        b=WO2o2TCqNuN5XPJrtzN3YUSMQBfgk8jMSIanrxpSVWK9AJ/FzxyV56yNPWGOeTuiah
         3NcWYGfi12JxLFoMQcAkqgU9pqxtkd/VTtopNdZhX4tHncBRueMJ28DfN9ZrMlg+cJXK
         fl+wz3i1EOq4ID8Y5C2molBz+N78/io18BsWKq2/XOBYziCd9NqtOTdncUL7ii6Gwpqf
         e18ejwEy23d1WirNIRezAoA9UXJ5LI+nrMHuLk6wGpm1IV77Gmdab4f4jtMGzyPZJLpt
         B53fhly3EcyMMbKiVP3O53c3P87trk+6laeBR2QT+YcFGXrbHuCsnSRbBJgcHdcNl+Ho
         oF3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764884340; x=1765489140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7a4apymdvLMzvSssxC4jYelA1RIA+3s9lZemZv4hiVM=;
        b=ldQuZTnWvMKD9sUD5vtEcLFuiOYlS9jBUK2ps+1UXhlqU+CSVubREVj2Cm5nQlb3nC
         5utGPVyM+BHvnh8TCYn69oF0tygnkrnPkFJkJnY+JpmJykYma0br65nV7jZ5aXcR1sha
         +iy9blkuOnTMPxEXJqGQaXj/+MZ8z8PVn2JEN/wVyRUfm6G9ppOEb8zFPNtgwacG6rn1
         MfzTIna553s+HgjWjYSax16oBNWRlDk7CuGdlxpH8K8FYpDOMjBPL7znDpyQli2JkuD9
         aIg3a+Cs6/YBup9D+EZeEyXWwK4ZQ82192A7ZBJiOgAfiVB/y8rS23SG1+djUY5bTpPG
         4RdA==
X-Forwarded-Encrypted: i=1; AJvYcCU9KUbnu4LUcZXjdXwQ0YlVYW52CSD1iYpCFDnCcHocuY2qoSZH8jnI/au1YyyvFDjMq0jhsIVizw==@kvack.org
X-Gm-Message-State: AOJu0YyroBL5HgfWHsxQ9APdYIOqeIXvO1MywrKLEw9t+MG49OxUI8yx
	IHw5wHprmzsKmHMcfG7ENnlOyfXQYdEzVHvYGfzNYiKdvf0x8lVypDpwo5WBvs+palI13Xtdmp/
	VoqgyL+xOmkXCHF1mJOP78sSOx6BMWIk=
X-Gm-Gg: ASbGncvRHbTJ1P9A3a29q+8EiL9Cv6gec0lZtyFuLTi6RT+EpokjYU0xqqt5/uRvlRf
	qC19AVGDIk+zrXkhgZVY7zqHECoC731TtiZ2KpWREj1KS6jsrez5FeBM+s7ntaHUId8DI2vuHBH
	fhudN6Wfb5dc05hqELxRl21U0jsLCP5ozghaIBF0QQ//BGW5Ev0v7v2rkzwGdluOvmSsEj1iSkj
	HtnbZDEcfHYI+ak6tHqICPJJo0x1ELkDeY3BHelm6i7zKM0uiFccRXj7fFg+FGn3l9mvuJ32PdQ
	Mt84KHI=
X-Google-Smtp-Source: AGHT+IECekJX45uTX+rdJAmlqhj0+olEbSOJgBEbG8bNxunXp+W3mrNWLKVJtLnQ1vPBK4dnSvd+pVp/HLiKh/idEFw=
X-Received: by 2002:a05:7022:410:b0:11b:82b8:40ae with SMTP id
 a92af1059eb24-11df0c48844mr6019656c88.18.1764884339502; Thu, 04 Dec 2025
 13:38:59 -0800 (PST)
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <20251204141250.21114-10-ethan.w.s.graham@gmail.com> <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
 <CANpmjNMQDs8egBfCMH_Nx7gdfxP+N40Lf6eD=-25afeTcbRS+Q@mail.gmail.com>
 <CAHp75VfsD5Yj1_JcXS5gxnN3XpLjuA7nKTZMmMHB_q-qD2E8SA@mail.gmail.com>
 <CANpmjNOKBw9qN4zwLzCsOkZUBegzU0eRTBmbt1z3WFvXOP+6ew@mail.gmail.com> <CAHp75Vd9VOH2zHFmoU5rrQCRqJSBG2UDCfKgvOR6hwavDVqHeQ@mail.gmail.com>
In-Reply-To: <CAHp75Vd9VOH2zHFmoU5rrQCRqJSBG2UDCfKgvOR6hwavDVqHeQ@mail.gmail.com>
From: Ethan Graham <ethan.w.s.graham@gmail.com>
Date: Thu, 4 Dec 2025 22:38:47 +0100
X-Gm-Features: AWmQ_bkrTLjU1bji3dq_q0_9aUL2KpYGKaTrBSm-1EAw-k6T0Q2iOVkzFyxbFXs
Message-ID: <CANgxf6woLz0VBnmFqrhwQiLwrQkb5oLb+1tHoOU5+aN=a21k8Q@mail.gmail.com>
Subject: Re: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Marco Elver <elver@google.com>, glider@google.com, andreyknvl@gmail.com, 
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, shuah@kernel.org, sj@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BDDFC1A000F
X-Stat-Signature: tt9n4bq6bn6pzgq8i7aojghmz9iy8f5p
X-Rspam-User: 
X-HE-Tag: 1764884340-420169
X-HE-Meta: U2FsdGVkX18iCfTZrjamypK80y/k8NwOLRyfCWmV1LpQpKSKyUN3pDE/sQXqOVawg0SltiS+pAuguRSeR72fEeUqJOBbi2l4FCze3gAi7O3fqRgZ6Q7s3IyvTmsF2E6o+4QQ9jPBOGoB9SoEYpW7We2pC/KardNRcLBncsVEjLgl7JUKJPW1QpskJNVdye3SND51TZJAcd+rrq+3fm1YOfX/eKoE3807u4OAkTacWPPzKtEMo8y/Jw4agx8XgmsJqJO6L8yo4g4PplOEvEZRMwzywGQB/HSbziJvCPyasWINOxvbPqK17e1T0DqC7lWPOxqSSfuAC0bxvDpkLyrXIcSGH8iariNhQ4ftXlzgv8kxjqkipz1CUxMwr6pEOiJYF8XevTGfHYrLJzXjt/hWdmXu8j3+73e7TKF7iEw3UZMVdndpLJvTgE+jLAFgpga00ot1shzVas7TwOdU1Ek5/39lJSWb/DjMnyhTl3Vcktqk+Q538qpKFUgIC0HgOWSWinh3Isa00sUkSjYp8Yaisvg2wLgE6uWFSwdn3amT9WqO67GeqWWgRI49AvJnZQ8qh4F/PQtGVLBRlohEKNNZ/0VXRW56JfW5PH/H5sdCpIr/6yWE4nNVC/CG5DWnkkUP/exPnRCO0R5C4J3ng2nYwZKzFTtBq7O1SBw78s7Rtvrt7k2ltOahbvpCaSzrmLbPk6f4UtRHzD0rpl28brRSTNQr3hxXaPtqLAT5nT4rhU7KglQYtQ1Lt6JdDw6zDelZ1Y3cAS/milrp3OQSQp3I/0pJ4Z4ovBwK3N7Ws+S6zZrXAPsNTFTQPyUNvlvju0HbP3067FzepFqLScuulUfNhXjjptNCO8V+hxBBb17/3DiqX9KBJU3tdK6FAFHtXfm7EIIMfonhXSmONm73abMDB+6rVBZuuErNkOCXJAqfZb/RLo1EFSI05cPeIvyvK5rfQVSiHoB8jTLk/P7Y73d
 Vs43gTtl
 wrG142KZ7F03DQWPlcoI1j0MqH1WCjJPS9BuIQyGWjbM3dKMNxA/Obpoh7CnOujnMywcbIQ+fwJYwfjOoNTopPKgV6TsE6+0eWgSVA7q7RtbT6bMYakbIUYr89ToF55wXQO4JqaT1kYh3Z7BngH/wFl7liGWZ1nvuERfvTGgD1xuqUcA8DWJyzAMuZxFV8HztF0AGkZI8SZhT68rkC53/ojKg8G212O4LEBFoq8pf5LahSYU9fzh13Itgx9uZUz1vMYnfJJUbFd/zUXJgW6lS5FfPZjJn0XTfIQ7jg0eJ5lo88vPBD7+SOlhVDYoq3mFAbLmPXPggnSFyc6MEOxyITdHRaQmun7lrENfns4Y2ukeynCYsS1YTRdjqVBQY4CV/y6PTy6NR8uIP/w0lnb7TjZOTGs9hdVfEldMKFOwwuZ+FsvuPC5+OEhy0nEBvLvJ8IIGffnabWq0YsgwUetjWs5jrpev4b1hcvbRkajA8pd3enCtp8jV5s+JHLyiW8UCZ6anXiza2kdID1mfCnVrI7b2qbmMWnVLjKtsUVemZMEuMfcNBoXNVKch6scUbnztTFNblgu3chCndOjI+gdCL/Rih+6O44DUVqQij
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 4, 2025 at 6:10=E2=80=AFPM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Thu, Dec 4, 2025 at 5:36=E2=80=AFPM Marco Elver <elver@google.com> wro=
te:
> > On Thu, 4 Dec 2025 at 16:34, Andy Shevchenko <andy.shevchenko@gmail.com=
> wrote:
> > > On Thu, Dec 4, 2025 at 5:33=E2=80=AFPM Marco Elver <elver@google.com>=
 wrote:
> > > > On Thu, 4 Dec 2025 at 16:26, Andy Shevchenko <andy.shevchenko@gmail=
.com> wrote:
>
> [..]
>
> > > > > > Signed-off-by: Ethan Graham <ethangraham@google.com>
> > > > > > Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
> > > > >
> > > > > I believe one of two SoBs is enough.
> > > >
> > > > Per my interpretation of
> > > > https://docs.kernel.org/process/submitting-patches.html#developer-s=
-certificate-of-origin-1-1
> > > > it's required where the affiliation/identity of the author has
> > > > changed; it's as if another developer picked up the series and
> > > > continues improving it.
> > >
> > > Since the original address does not exist, the Originally-by: or free
> > > text in the commit message / cover letter should be enough.
> >
> > The original copyright still applies, and the SOB captures that.
>
> The problem is that you put a non-existing person there. Make sure
> emails are not bouncing and I will not object (however, I just saw
> Greg's reply).

Understood. I'll stick to the single SoB in the next version as Greg
suggested.

This address is permanent, so there won't be any bouncing issues.

