Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71033C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 573D16B008A; Wed, 14 Oct 2026 13:00:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 524026B008C; Wed, 14 Oct 2026 13:00:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43A356B0092; Wed, 14 Oct 2026 13:00:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1AC1A6B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:00:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A20D9C06BB
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:00:04 +0000 (UTC)
X-FDA: 85321844328.25.7B0E98F
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id 615A818000C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:00:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=GDcLTiBh;
	spf=pass (imf16.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791997202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkE0Z2/i0i7EFZjNtTFKeqi6fbMm7UzE8UbD0jLuu9c=;
	b=J1VgcBv4uIWV9GeTeOeWQbAuWcTAIhzbkrPgz0K7bqhdrsUhY5uL7k4iX7usFdkckeE05B
	8B2BjZW2GBn9M+WHOCOchv4/Js+/21X8N43uHowOV9dAaSe3pe8BoSrN4n+j9LXDF91u9C
	ZCn8Yopbth6Hc4XqsQYHldMgXGJxe5s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=GDcLTiBh;
	spf=pass (imf16.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791997202;
	b=iUGfakUbV1bWlCwqfdiUIxBCXc8HAI+A7HP2FHw8CR5Rahbji+v9xQmy7VTez6XjV+YBE0
	a3VDKWnRv8uUauySlqN1LJy5g9wWFMc1h86wepB00TGRW/iKvJfLdgptBM8nUOeGbLYlHQ
	23VWBKQGZ5tk1m7JAR6o/Wq40NAiy9s=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c350db5a761so567971166b.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1791997201; x=1792602001; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OkE0Z2/i0i7EFZjNtTFKeqi6fbMm7UzE8UbD0jLuu9c=;
        b=GDcLTiBhSw79ch6lPrO+ZlYHb/TUTfqYUCd6sE8r1JU53fp09k3G/jvR6HRGr5045K
         EWLJa+Wr3ZKo2VAOCxAa0eb0r7y7MiY8BroSjOAV2ujUAJ0CXwlduY/vLVLYo2vKPQoA
         5k9SoLwyC0JDw95Ub+AcpluKUE+0AGYr6wWU4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791997201; x=1792602001;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OkE0Z2/i0i7EFZjNtTFKeqi6fbMm7UzE8UbD0jLuu9c=;
        b=WGz73fwaHcXefSFhLkCK80zyBNZJFsOMFY/tha5EuEn54W2fuaz+crl6PogYDq5PyJ
         Ibysy0EzhQ4Fe/mxxB5H/N0vMXFrotGFvoZeqsF3KvikZuB6OzaVaY5LfvHrADixZiAE
         qC8kv1w+umCqPrWeKlfej/wO2vuLw9Lcs7UyqMmjgKEY3TlGAJVqL4wo1p3iIrvJyCWb
         rrs8sMcNRC4DWTMc+94UfKLYoUlZWy6/3sLiiv6ZHWmnH9fHCSGV+tER/c3lGq8tL04v
         4dQLl01nYB8T5BzuytunXjaK63kf8LYpycCifpGu5uFKyN1uFdkxE0diSSfSKsTxDCWS
         ayUw==
X-Forwarded-Encrypted: i=1; AKwUvBwo85zVBc8+YPnbuxs5tjTxcwVsjmdSoJh8JQ8Q7EtLGjXlc+IEPDOFOUCjGEwsaLEeall0Gt24Xw==@kvack.org
X-Gm-Message-State: AFq9FYKoVSiM9zCPRly9IMTHsus9AM9dWJ2lio/lsVDgSinzZz/wUnVK
	ApiysLyEx49RmyJQPe7Pbk/GncH5guFa7KUTtWA3dBlplwJHJhJthnbXCTf/F6Y1+cWNGFIybFa
	vraI0LHc=
X-Gm-Gg: AYBFou0az7+ncVqmbMenIUa7YO66VvA8tl+9q8iaHsXlUDeYmy9lU5vKl36G/yacF2E
	ST1Bxmoq/AhbmMWC69QQCXilSpI14u6ZWnXhgCJP1PhfCBWWsz3CrP3KFhVAg/d4LpH/uB7gfdd
	QlP0zl40uLM2bb/KGCWKbeMphuC/TDSSV+A2NMV59BiqntShrWuENK+Ys3jQXlwuLXteJfYzuER
	A1f01/VP1yNnpduYifiw901ZnYOSVP96h01MqktRauOSLY2ZNN6Bl1Y3sMX+3dQGjrtuqSwwoZi
	0QgDTXH/z/K1hbdx5MdpgqHu1/neFiNAv5DTt2152PE4l8r8L9elACDpwOyvdXj87sH7KMiFgoT
	pNEhYLnDHs8t+vfNPoj+UzvAQppqziuy7q/Z1701L9y9mgceWa1/pb6AIGI0Pxs7OdFxK5+WC+0
	1vZp5NwVE1AQHlLY051rj2omJ+4UAFr86vzgri74ycMJQFscoC+TAxumhhq171clzxFz2FLw+62
	rhlsMX1VUI272gaOmP0Ok1vLkq+7LkVwOk1QUIcwY4d+Bei
X-Received: by 2002:a17:907:3e8d:b0:c26:36c4:858e with SMTP id a640c23a62f3a-c31aa018731mr1498490766b.25.1791997200860;
        Wed, 14 Oct 2026 10:00:00 -0700 (PDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3ed9b3abe2sm6490766b.38.2026.10.14.09.59.59
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 10:00:00 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c315729ad50so720939866b.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:59:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwZiYj0NO9cne9i0gYsmKOjhXKiuPClfaF173J2NDku+cwig3RHuwegwy5zcnEnIXntNFWlWvCoZw==@kvack.org
X-Received: by 2002:a17:907:c0b:b0:c29:5215:b2d2 with SMTP id
 a640c23a62f3a-c31aa016eb5mr1683734266b.23.1791997199620; Wed, 14 Oct 2026
 09:59:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
 <as690Xcu7FxIDYjf@thinkpad> <CAHk-=wiak+h+d2tZ5W_MwRzatUP=hJKn7cpGjDxArG-gwgHLXg@mail.gmail.com>
 <as9-2cIuGuXwE2Oa@pedro-suse.tail5790ac.ts.net> <CAHk-=wgkoAuxNXga29nQ8w7GxdqR+4vPAUhPsbfp+gzKrb9EgA@mail.gmail.com>
In-Reply-To: <CAHk-=wgkoAuxNXga29nQ8w7GxdqR+4vPAUhPsbfp+gzKrb9EgA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 14 Oct 2026 09:59:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=whzkNzkBmCspHYd80D1Z=krDc4SgVC32=pJ5PtEgqSDrw@mail.gmail.com>
X-Gm-Features: AclHuK8rFSm3cd3995TX4NGfeXZ5GusuWKoXTlnl6-nGHAqR468IMtyKx0G31Q8
Message-ID: <CAHk-=whzkNzkBmCspHYd80D1Z=krDc4SgVC32=pJ5PtEgqSDrw@mail.gmail.com>
Subject: Re: Improve page refcount scalability
To: Pedro Falcato <pfalcato@suse.de>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, Harry Yoo <harry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Ilya Gladyshev <ilya.gladyshev@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 615A818000C
X-Stat-Signature: nixeustsywjisu9ezpdbx87qrt4gihpg
X-HE-Tag: 1791997202-1332
X-HE-Meta: U2FsdGVkX19lBAyTL4lQwnd9DhM3VWVhgH5U4VK2YPSGmn4y/oXiXGxJekP0mqS0fyQXNLaZKPRJbJs/wcrHw1xRHevCJV288E77RX+e3VrgxlFl730NpbMcRrjLGZfzEhtzJaYsZ8lBrm8EPJFKQdMMD9/k4fjTn+qNKYASFKq37k3CC/sRl+xE+mateIzuIwK+AYBZAVY6cgNF+WTXQPtpYlSK1VEO+8EZwfDvSdAv9uM3XTR2lMOUeoh8G3B47QJRjGatqHjctCHxVXaPItMS29NUtI5xAlGV6egTSLNKI8+IjNq0lTqXvS0vTbGdhKD6NxnR9/EcmJkBg+qoCyfIB+RxKvl8lZOpDN8qQBJNbEaiGFUX9wtgE+4T64+wBPk6x7pFKjCx7dxgjIX0h/aiiTPy+IqJgf08B9/6QHi8ohcRq9keJUdT3Sya6uFM+XcQP+cTRf7YsNF3JpqHz2nbAUBx0p5Cwi21zGrSL7e+dtW8jSIDAXp6fiu99m+tr/Y/gs9BBglayjC1S8PcWxy5NuKV5hkZRtZqwSIR+Ex7cmdOdgmMTyNK+rXTEA3mGxNsMeZKsdGzLle9uxmHnDr87azFQIkVrwgL/Q/XZ8HMaHCwNRjF7MtD16JowxiQdfiVzvnUKBQImr1dIYTeQKtV+dwYIe0o0fTJQnAUoKLOliXUgNLlXAsT6F/1h2WC134/U7ui/bEKL7yIoa/6Gw1u8vSmuaHPNWhV/qtLTgSau+xE9OefTf6OjXAPPa8c62RUOXpdFRgX+EKTOmXrn7XSssIrz2YXUz0G/ToRvw2QZ64iB7guxAslc0GwOxTCFptOcRRwqHLeWSnHnLIw3ATosyBYtrGnQcQqs/9ioJOpGDLXz2r5gF9Aor6KeXzlnQGYEjh8oL6VGZwQ6+JoUPCvigYhyEef+pdPE4AVHSQ7RjHs/gC08pack59q6TnEIXfYXyXAqDlVvtipeEA
 Ftf6vKAB
 AOA/0rNtVGMfE64K5GrFqauBbr4Oj/xZyhhoc7Gpcpw6CEwHGrX/UgsNmRlc0oeT8VF4n/5Brz6Q5H92wMh/ewmS5o8sAgAUnN6ILJSYDYti1Og4RLF8fKIeAz9iuV/cHUw/abPwDP0j5u5kq8LX/yj7lObcNzz8MwUo1/KzzQJsCbpfYZgnH+28aFiyyPkAo30dB+ZGLlG6oT6UwU/fYmcyZ89ZiHUp6zq7iPEQ+lWJLPMNlZYiGb4XyaAugSasd2Wo0RiQV2kcxyETDC6rX0xpAc/5rWjucnF0I6ja3UIxSnW1p9BuiMFAdtoY7EB6c3/T/b+RwoQWZDRIm8e3IdVXXLxi8+PTb8TTbx/FBKqjse03DnQcuzhyrOndOtDGKG7GWY0lWzwdx28KQ8NBTLvqaDRK12BPvAZjDLQueh/X4QwBhbBE7Gxx/fjLuExJ0wvT240SvnsYX+bZVXduUwphG38e1GvX+ch5S5jyDozSuDTsK2Xadk/Y0xiCmwfZUruh9tkllhtmV31H/gBibQ2+5Ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Oct 2026 at 09:25, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> > How many pages (as a %) are you seeing as marked PG_rcu_free across a boot/
> > realistic workload?
>
> I haven't actually checked outside of "a normal boot doesn't cause
> even a single accelerated RCU period". But I'll go reboot into a clean
> kernel and see what a kernel compile does.

So for me, after a boot into a full desktop environment and starting
google-chrome with my usual setup (18 tabs open), I have

  nr_free_rcu 0
  pgfree_rcu 73
  pgfree_rcu_done 70
  pgfree_rcu_mark 34038
  pgfree_rcu_kick 0
  pgfree_rcu_drain 0

IOW, I have 135MB marked for PG_rcu_free - sounds reasonable - but
zero actual expedited RCU events.

And then, after having done a full kernel allmodconfig build ("git
clean -dqfx" + "make allmodconfig" + "make -j60"), the numbers grow,
but:

  nr_free_rcu 0
  pgfree_rcu 32107
  pgfree_rcu_done 32107
  pgfree_rcu_mark 1395272
  pgfree_rcu_kick 0
  pgfree_rcu_drain 0

so a fair amount of activity, but this machine has obviously never
been under any memory pressure.

What do these numbers tell me? Not a lot. That pgfree_rcu_mark number
is cumulative and keeps growing forever - it's just the count of pages
that have ever been marked. And the best way to grow the
pgfree_rcu_done numbers is actually to then do a "git clean -dqfx",
because that will delete all the generated files - and that was a lot
of the RCU marked data, so now it will be free'd.

That actually makes me think I should go back and clear PG_rcu_free on
unlink - at that point the folio can no longer be read. I used to
treat unlink differently from truncate/hole punch because of this, but
that was in my first version where I marked the pages for freeing when
removing them from the address space. Now that I mark them at read
time when they are 'hot', unlink() is still going to pointlessly
rcu-delay their freeing.

Let me look at that.

But the short of it is: normal loads without any real memory pressure
simply don't cause a lot of actual RCU events at all.

          Linus

