Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D856606A330
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=IkKF8B6Z
Received: by kanga.kvack.org (Postfix)
	id 8A5036B05B2; Mon, 23 Nov 2026 08:20:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8559B6B05B3; Mon, 23 Nov 2026 08:20:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71CD86B05B4; Mon, 23 Nov 2026 08:20:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 403D56B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:20:09 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D63A5C08C2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:20:08 +0000 (UTC)
X-FDA: 85466442096.05.B096F4F
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6E88140006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:20:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=IkKF8B6Z;
	spf=pass (imf17.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795440006;
	b=O5JiqelptvyDLWAGJrH97itYQ2plt32dP8uj3UkYtF9Rsz/53/e5Ln3dneBsA3/j/q5gP9
	2fsEyUAY8FHOCx8vy8xiIFFhkEwITqvzXN+WPEMhoblJMp0EaARGVIKhA/waEjjWImF5ia
	9M1A/gXe7rEmkdq2kNmOdVoS7YDF/C8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795440006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cux1q2zTGzqkom+b4m1/fgFXJParUvZagzTBGFrsucc=;
	b=lRKVpVk+atGUrMIpcLduHzpj+fi3/9jmwaqRhYYLYVIwOBnF3f97cvjw2r0Vm8VvEGfHEg
	Bct4peLbSMRJY7p1ojNadM/1Fe/zxDpPA18WCvlRtGsJ5u2cjsiDxc0gmujx9L7tdIp9Py
	uI7VgR+qM/qstg85l+rETOs1GkdO3yw=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=IkKF8B6Z;
	spf=pass (imf17.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c4d581da0aaso434899066b.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:20:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795440005; cv=none;
        d=google.com; s=arc-20260327;
        b=mMFZyZ078EmosepO3XS/dTRNruu/35FYKmO3ICA3jqiJr3O+ojzyig3dxKU6VEJI0q
         6pHd40Xvy0COm+4U84t6POP2Hzy86XTmHcLw2wBSrdz5GiY1SJhO5YrOovW+y1S4N7Ql
         DkblrzIvf9/uo4J0G9NIiQNiM6izRcbWPTESHaFjx9EeXy3dkvoJ/0SkDpYz2RQuSsGl
         5NaGDc0MMxhRgMFRKngE0gvKVPeBApsrCXCG1Bs8zXN68hwP4pw3pJicGwi3CNZLTbNw
         JWbTwI34aa+1x5fPzcUto64IP3D/lS2h6CM2Z5pNDJUVig/JdSC1ycoR+vx6FGjxIxTW
         /W+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Cux1q2zTGzqkom+b4m1/fgFXJParUvZagzTBGFrsucc=;
        fh=LitTwcHm5EPgbjht2N/cd5WroBew4LA5QACJakWGSPY=;
        b=bSw5egDNPSFl+X3nxLAaKgn8w4mmLi5pGfgsNqqd3VrKn/bycdt9McFL4fYkJU0cRo
         F6JQRt9lQDQgoq/Gyz2ZUPSyipCXgZ1EVx8pCRTzepr4PS4Qe+BDsdMmhlHz74DpOjkA
         6Ki14Po1M0b/63Mqvaf6LIUUMiNYzYOkhDDOS8yQD5ptLKHBM8bWlQC065VYxDnD8e7U
         6nKgZCixJ2Jtu4OPlrlOT90ogymCrI/X2fSffhXBQbG34hoip0J5iRntUneWEQCRj8/c
         3vFKGAgOR/snQ44e5fzdWbDi286KpXEHNhByFCYec50z33aW6vd2TpMqqau4SjlXVuL3
         9PiQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1795440005; x=1796044805; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Cux1q2zTGzqkom+b4m1/fgFXJParUvZagzTBGFrsucc=;
        b=IkKF8B6Z2d8FuW4FqMg9vcE/7KJYOq9qJkttlEnOyZrCnD1B9r64fgMIzpr2tbXK7b
         NrpeVetp8YolQI0CJSAP3nq+ESq+4S7HIdqBspIQRSnroyNzgMHf9+SuZTPcZ4G/fFDI
         qTy7fwOwr2g+6XR625Qs/5GvYbP4U9I1W/MKD1/5KnnFzfd+kZNv9Qf9rSF/LeQ4B5Ki
         KCl2kjanCGpCLD7JFM5sAB5ymLAYHwVvFI4OYuL4MEQ8CCXpT4Dq4IT1NSRkU0SpMEag
         R7f9k/cB6c1jIhDZ/XOv+fKMXgNk4ygNkrvVoHL+fSuBPsWEdwseKTHMJJCF10hFL/uX
         JObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795440005; x=1796044805;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Cux1q2zTGzqkom+b4m1/fgFXJParUvZagzTBGFrsucc=;
        b=F8Bqxtu8zU/aKN5M9fAsSmxuT8elx5Dml9gE14+AjrxQFT19CPNS/uqBywUNqgc1MG
         QXmNgawRHMDJodPSw204AJlI8BBpBlVVYFw3+gyqh7x42n6bsaIIWpqVK1S81yuB6lks
         IEqVNxPDHl9wSY99FtnNlcejQbZOc86ddCdrK3aTDd+o1N65Gtut5ifJGmPxKzRklZBx
         aB0vZ1T7nH0R9nTMVQTPOLeVGjc7z1y+UG8A9L98GXst2ggH2lmAK3HOE99S070C8Qr3
         mPn8SFo0EPOxBMaqHrSrLoTOsFSnD26C76og50TpVCEz+nRokmt9J4sx/K1vTku4Ldyb
         7tWQ==
X-Forwarded-Encrypted: i=1; AL+hErHosfdTXUCaK5Ff+PQqBKD7FDqrGVfCUuV8ZJzKzglpFrdYMwTBxId0Kc5CvOtGk4PB7QYwpLoTRQ==@kvack.org
X-Gm-Message-State: APuU4Z+eHExKV5QxSpIvEOT8D4gaAvW53GePjo7yvcD1RZAT+YZoQJT2
	ttKN7Yf/qRmsMznQ1okRo0B0x8vQnmJqNxLe+yp5B+yuzHCCSwiQFOM3MqpRF49AuVqfY8WOKHY
	w957KkWsXm+SxDH4M618TFicySCmrQ5NczhcBV4K71qZv8rBXxk+s1W4=
X-Gm-Gg: AZFdTZcTGOre2oFLz3fg2rWFxqgb49aXu/yem5QLBrEDgvjBlHk+Ul519kGDk/5ppwi
	DS/jb9OOlJKGlxqJIQfCGLUXB8CSYWbTVqYSOEv6w2vXeCSlMHlRBzPzP54TYOeq5wC5au/uh5P
	qP1JSIeUFdW2RRfxX13nczSKLSTlMJGtEBG4ZoQXLgTa/GIvTYqTOcXTkJrLLRfJFEU/Mk8bQ1K
	LQtFQ3HKAalV3P+X+kX7lPwYK6hZ8u3JvFUgRfwrAiMw/4G122IoFHhxI+6TaBBcnqf/BW+pfiA
	PHJmQ7h61z/8tbFImNPfA567bw2WhFRVLa4afic8lgnWlynZdPcXUpiPQ69gzmJ+/gpHXIDdSqu
	1zU0x4PPtiTtrweZWqa0KwrsQ+rIHEPFb9AfGv9Ig4VTZl5tg4oyzSzu5AH8dusEMGA==
X-Received: by 2002:a17:906:447:b0:c46:cc9e:a143 with SMTP id
 a640c23a62f3a-c513ab1d008mr716021166b.26.1795440004829; Mon, 23 Nov 2026
 05:20:04 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103113711.1832834-1-max.kellermann@ionos.com>
 <20261103113711.1832834-5-max.kellermann@ionos.com> <CAGsJ_4wpd-e+xjm5KwihVziAeVnQp3XYG=+-BKmx0SVEhmyqqw@mail.gmail.com>
 <CAKPOu+9textOydxZYng=Bo9Sf91Wq_7rv5r2pBrhXOfiex=qGA@mail.gmail.com> <CAGsJ_4zzZZSaAwG=VLhuMvoD0YcAFdqyUr-8zRSibNw28j8wzQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4zzZZSaAwG=VLhuMvoD0YcAFdqyUr-8zRSibNw28j8wzQ@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 23 Nov 2026 14:19:53 +0100
X-Gm-Features: Aa3M54r6cbzKznLbRSijNuzXT2VmkZ0RfouvSkd09nroJFvuUAh1A-K_PM2wVL0
Message-ID: <CAKPOu+8oMMQKSMLL04QqULtx03reOPJBmw6EtSHbYCyoZQ83Bg@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] mm/mglru: avoid redundant rotations of young memcgs
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000b450f30660f17354"
X-Rspam-User:
X-Rspamd-Queue-Id: 6E88140006
X-Stat-Signature: wnb1m4f346dwm6ye5e4exq9khu9mjqi6
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795440006-315603
X-HE-Meta: U2FsdGVkX1/sKiVN/rc3G6WCPj38N8eHdQ+X2qpeYL3VoRh2/pMI+/5jm3zNpehxEDZhwC2xs7aP6MNaGfWfEz6B7ysL2OOJb7c4Vkgjx841CTVEgv5Ts7XDwFeiTIgF42GXkwQq+3ErWNYsU8ohfIG/s7PRZDVvs3+LEZzO428M0Ueu0fmfWwP1eddOPto/OwiI7wVYgWQM3grEd7v6JSNChBEX7PXcBCK3l2++8lpsX1IHtF7jpzlMK5jgo7dz0RdUxXQ9CQGqWHsskkQOlzGbS6WRwKIPFRSRjrj3YGgRLjQMKRa4bGAeuOsTGqaFhfE2oK9egrEvnD/mDnylqdWVse5XY3OEfUfPzw/ajh3IMu84OacTvOlN/MQcOc92Egpr4XOOYOswmUVMX4QstE8/wcJOfS4+EqCKgP4li47jUVajYgGLFUTIetPQtk02ltD6ii/7Mt4ZyXlYtSj3XgclmvokrUuClsqca3ZCpliFmi4Y62E5LYeRdRt7zkK+/9WSbAY7NVCxsy2a5hTy8A3dPCnyjluPpohGnwbAAxM0BPaNCVvcwb5M3Civv2XphJFH3e8k9QgAXjt9QwZ6Pc+1GW90z69n0j9GRQsuGrEzQU1y0oR1duR6e/Fi9oBTkPY6zrjNfUshzrehkDYWutvEsQ+WSyfYpsJE3Fr2640iCcoLQF8p0aj9U0TPwJfq4vvPb9XXY0Jlau6AWNVTG/9bh/8i+I2bEetZK5QCGUCm3iDkmlLz8Hd3ldZfLbSSjJBO958g81ybttZzm4cZ6w4Ri1X0gx/vScYY0w3AUBJ7vtuBN4oBXCrO+6G83BJvlxM09Oubf6uv5RF83li5w/YAQeoDUMPqC6220Zd5PIUHhwpP3t5/WAeTjLGTik/2lxX1kThnm04AjhqheEmvk5PxfNGKrHKHmtz0uzzG3fZd4xnKSs80i7p1SFuIJjY5xid7uLAsrAiBFdXlWrS
 yAoTQ3Cc
 KKpwleyJ/s3k6eaWlGVP5wheEmepPlhol+7DdaLn8gduh5d4IpC20nRF2U7XLZmquZVMKqo5o2XS96g0F0+UiZe1X+g9VFnwLY/3IKZwMNNLuro0x0Ba2C0gsH6f6tGlk/uGZ83Bl8f4CZjY6QjxRtENi+z8bsQDJYP4xcTjxZonBeY6ljOu5chem/USdojkq+Mx5JqePP4LoFVY3n1A9UY+oanyClSgve57XiMmqBthx7Da94yhL9cRbWj3qguw1CEc4tXPPgd5aXS01h4FGetXFOkhL+W6Pfbp7t6JreBM4kjwijgITV0SJ5H392pGYTAy91h+SwgMoP6EWD43G/jQmVRmUlLJ15i6mjHo4fWaf7owrUHKqPllmHuuX5TtarX9zKSV9c9U0NFvCCQMEuPPTz1LouJCSiuMHJMm+GuSW2oZtrGwjDgXwxtHzq+4U5pqn09QEhzK3FFhD+8MEaG+LvqrElx6QGMlKwPPLkSlJ7pn1o1vILeWGNLzVy9iUJSV4QdCU+dGduE77Z0rh0BeLrzi0iBw2y8T9d1+iBpmvJslxYuEzj7lFbMbPjvn0z6gNjlbG52/mDYjIf0Lu8mYKhP7ICzio9AS7Hpa3NyLch30m6dkDN+vd+KjWphTsstaSe85/z2vhtsEXYhyh2yUBDfI4jKmgaqFrS7OHqSAnuxMaJaXQjHGCgPsqNPyHh3N0JoIgQi1fzj2nG7IjtvAEvofB6hVd/6t3xH7lDyaASLSZ7vXt1fvpmgh+GsfRpvmTzAZ23ZABpcj4KFx6usc2tFPjCgRduS56azIw590pktXN3uVC15gHVN5MdHM+s5YM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--000000000000b450f30660f17354
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 4, 2026 at 10:08=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Wed, Nov 4, 2026 at 4:27=E2=80=AFPM Max Kellermann <max.kellermann@ion=
os.com> wrote:
> >
> > On Wed, Nov 4, 2026 at 6:18=E2=80=AFAM Barry Song <baohua@kernel.org> w=
rote:
> > > > In my micro benchmark, this increases the request rate by 36% and
> > > > reduces the average duration of each write request by 27%.
> > >
> > > Could you share your microbenchmark somewhere (or post it here
> > > if it's not too lengthy), perhaps on GitHub, so others can
> > > reproduce it? You could then refer to it in your changelog.
> >
> > Will do.  A note of warning: it's ugly LLM slop, and if I had written
> > it manually, probably 99% of it could be removed because it's
> > pointless garbage.  The LLM wrote it for me before I had any clue
> > where the problem could be.  It helped me find the problem, but
> > uploading this garbage triggers a bit of shame in me ;-)

Here's the script; to avoid the pain of reading it, I let the LLM
remove lots of features that turned out to be unnecessary for
reproducing the problem. Prepare with:

 echo 3 >/sys/kernel/mm/lru_gen/enabled; ./lrugen-repro.py prepare --live 1=
500

Then run:

 ./lrugen-repro.py run --workers 8 --duration 60

--=20
Max Kellermann
Principal Architect
Hosting Technology

cm4all | Im Mediapark 6a | 50670 K=C3=B6ln | Germany
General information about the company can be found here:
https://www.cm4all.com/impressum
A member of the IONOS Group

--000000000000b450f30660f17354
Content-Type: text/x-python; charset="US-ASCII"; name="lrugen-repro.py"
Content-Disposition: attachment; filename="lrugen-repro.py"
Content-Transfer-Encoding: base64
Content-ID: <f_mwtal3re0>
X-Attachment-Id: f_mwtal3re0

IyEvdXNyL2Jpbi9lbnYgcHl0aG9uMwoiIiJFeGVyY2lzZSBNR0xSVSBtZW1jZyByb3RhdGlvbiBv
biBhIGRlZGljYXRlZCBjZ3JvdXAtdjIgdGVzdCBob3N0LgoKUnVuIGFzIHJvb3Q6CiAgLi9scnVn
ZW4tcmVwcm8ucHkgcHJlcGFyZSAtLWxpdmUgMTUwMAogIC4vbHJ1Z2VuLXJlcHJvLnB5IHJ1biAt
LXdvcmtlcnMgOCAtLWR1cmF0aW9uIDYwCiAgLi9scnVnZW4tcmVwcm8ucHkgY2xlYW51cAoKV29y
a2VycyByZWNsYWltIGZyb20gdGhlIEhPU1QgUk9PVCwgYWZmZWN0aW5nIHRoZSBlbnRpcmUgbWFj
aGluZS4gRHVyYXRpb24KcmVxdWVzdHMgYSBzdG9wOyBhbiBpbi1mbGlnaHQga2VybmVsIHJlY2xh
aW0gY2FsbCBtdXN0IHN0aWxsIGZpbmlzaC4KIiIiCgppbXBvcnQgYXJncGFyc2UKaW1wb3J0IGVy
cm5vCmltcG9ydCBtdWx0aXByb2Nlc3NpbmcgYXMgbXAKaW1wb3J0IG9zCmZyb20gcGF0aGxpYiBp
bXBvcnQgUGF0aAppbXBvcnQgc2lnbmFsCmltcG9ydCBzeXMKaW1wb3J0IHRpbWUKCgpDR1JPT1Qg
PSBQYXRoKCcvc3lzL2ZzL2Nncm91cCcpCkNHUk9VUCA9IENHUk9PVCAvICdscnVnZW4tcmVwcm8n
CgoKZGVmIGNoZWNrX2hvc3QoKToKICAgIGlmIG9zLmdldGV1aWQoKSAhPSAwOgogICAgICAgIHJh
aXNlIFJ1bnRpbWVFcnJvcignUnVuIGFzIHJvb3Qgb24gdGhlIHRlc3Qgc2VydmVyLicpCiAgICBp
ZiBub3QgKENHUk9PVCAvICdjZ3JvdXAuY29udHJvbGxlcnMnKS5leGlzdHMoKToKICAgICAgICBy
YWlzZSBSdW50aW1lRXJyb3IoJ0V4cGVjdGVkIGNncm91cCB2MiBhdCAvc3lzL2ZzL2Nncm91cC4n
KQogICAgaWYgKENHUk9PVCAvICdtZW1vcnkuY3VycmVudCcpLmV4aXN0cygpOgogICAgICAgIHJh
aXNlIFJ1bnRpbWVFcnJvcignUnVuIGluIHRoZSBob3N0IGNncm91cCBuYW1lc3BhY2UsIG5vdCBh
IHN1YnRyZWUuJykKICAgIGlmIG5vdCAoQ0dST09UIC8gJ21lbW9yeS5yZWNsYWltJykuZXhpc3Rz
KCk6CiAgICAgICAgcmFpc2UgUnVudGltZUVycm9yKCdUaGUgaG9zdCByb290IGhhcyBubyBtZW1v
cnkucmVjbGFpbSBpbnRlcmZhY2UuJykKICAgIGlmIGludChQYXRoKCcvc3lzL2tlcm5lbC9tbS9s
cnVfZ2VuL2VuYWJsZWQnKS5yZWFkX3RleHQoKSwgMCkgIT0gMzoKICAgICAgICByYWlzZSBSdW50
aW1lRXJyb3IoJ1RoaXMgdGVzdCBleHBlY3RzIE1HTFJVIGVuYWJsZWQgd2l0aCAweDMuJykKICAg
IHN3YXBzID0gUGF0aCgnL3Byb2Mvc3dhcHMnKQogICAgaWYgc3dhcHMuZXhpc3RzKCkgYW5kIGxl
bihzd2Fwcy5yZWFkX3RleHQoKS5zcGxpdGxpbmVzKCkpID4gMToKICAgICAgICByYWlzZSBSdW50
aW1lRXJyb3IoJ1RoaXMgdGVzdCBleHBlY3RzIG5vIGFjdGl2ZSBzd2FwLicpCgoKZGVmIHByZXBh
cmUoY291bnQpOgogICAgY2hlY2tfaG9zdCgpCiAgICBDR1JPVVAubWtkaXIoKSAgIyBSZWZ1c2Ug
dG8gcmV1c2UgYW4gZXhpc3RpbmcgcG9wdWxhdGlvbi4KICAgIGNyZWF0ZWQgPSBbXQogICAgdHJ5
OgogICAgICAgIChDR1JPT1QgLyAnY2dyb3VwLnN1YnRyZWVfY29udHJvbCcpLndyaXRlX3RleHQo
JyttZW1vcnlcbicpCiAgICAgICAgKENHUk9VUCAvICdjZ3JvdXAuc3VidHJlZV9jb250cm9sJyku
d3JpdGVfdGV4dCgnK21lbW9yeVxuJykKICAgICAgICBmb3IgaSBpbiByYW5nZShjb3VudCk6CiAg
ICAgICAgICAgIGdyb3VwID0gQ0dST1VQIC8gZidsaXZlLXtpOjA2ZH0nCiAgICAgICAgICAgIGdy
b3VwLm1rZGlyKCkKICAgICAgICAgICAgY3JlYXRlZC5hcHBlbmQoZ3JvdXApCiAgICBleGNlcHQg
QmFzZUV4Y2VwdGlvbjoKICAgICAgICBmb3IgZ3JvdXAgaW4gcmV2ZXJzZWQoY3JlYXRlZCk6CiAg
ICAgICAgICAgIGdyb3VwLnJtZGlyKCkKICAgICAgICBDR1JPVVAucm1kaXIoKQogICAgICAgIHJh
aXNlCiAgICBwcmludChmJ0NyZWF0ZWQge2NvdW50fSBlbXB0eSBjZ3JvdXBzIGluIHtDR1JPVVB9
JykKCgpkZWYgY2xlYW51cCgpOgogICAgaWYgb3MuZ2V0ZXVpZCgpICE9IDA6CiAgICAgICAgcmFp
c2UgUnVudGltZUVycm9yKCdDbGVhbnVwIHJlcXVpcmVzIHJvb3QuJykKICAgIGdyb3VwcyA9IFtw
IGZvciBwIGluIENHUk9VUC5pdGVyZGlyKCkgaWYgcC5pc19kaXIoKV0KICAgIGlmIGFueShub3Qg
cC5uYW1lLnN0YXJ0c3dpdGgoJ2xpdmUtJykgb3Igbm90IHAubmFtZVs1Ol0uaXNkaWdpdCgpCiAg
ICAgICAgICAgZm9yIHAgaW4gZ3JvdXBzKToKICAgICAgICByYWlzZSBSdW50aW1lRXJyb3IoJ1Vu
ZXhwZWN0ZWQgY2hpbGQgY2dyb3VwOyByZWZ1c2luZyBjbGVhbnVwLicpCiAgICBmb3IgZ3JvdXAg
aW4gZ3JvdXBzOgogICAgICAgIGdyb3VwLnJtZGlyKCkgICMgRmFpbHMgaWYgcG9wdWxhdGVkIG9y
IGNvbnRhaW5pbmcgY2hpbGQgY2dyb3Vwcy4KICAgIENHUk9VUC5ybWRpcigpCiAgICBwcmludCgn
UmVtb3ZlZCB0ZXN0IGNncm91cHMuJykKCgpkZWYgcmVjbGFpbV93b3JrZXIocmVxdWVzdCwgc3Rh
cnQsIHN0b3AsIHN0YXRzKToKICAgIHNpZ25hbC5zaWduYWwoc2lnbmFsLlNJR0lOVCwgc2lnbmFs
LlNJR19JR04pCiAgICBzaWduYWwuc2lnbmFsKHNpZ25hbC5TSUdURVJNLCBzaWduYWwuU0lHX0lH
TikKICAgIHN0YXJ0LndhaXQoKQogICAgd2hpbGUgbm90IHN0b3AuaXNfc2V0KCk6CiAgICAgICAg
YmVnYW4gPSB0aW1lLm1vbm90b25pY19ucygpCiAgICAgICAgdHJ5OgogICAgICAgICAgICBmZCA9
IG9zLm9wZW4oQ0dST09UIC8gJ21lbW9yeS5yZWNsYWltJywgb3MuT19XUk9OTFkpCiAgICAgICAg
ICAgIHRyeToKICAgICAgICAgICAgICAgIGlmIG9zLndyaXRlKGZkLCByZXF1ZXN0KSAhPSBsZW4o
cmVxdWVzdCk6CiAgICAgICAgICAgICAgICAgICAgcmFpc2UgT1NFcnJvcignU2hvcnQgbWVtb3J5
LnJlY2xhaW0gd3JpdGUnKQogICAgICAgICAgICBmaW5hbGx5OgogICAgICAgICAgICAgICAgb3Mu
Y2xvc2UoZmQpCiAgICAgICAgICAgIHN0YXRzWzFdICs9IDEKICAgICAgICBleGNlcHQgT1NFcnJv
ciBhcyBleGM6CiAgICAgICAgICAgIGlmIGV4Yy5lcnJubyA9PSBlcnJuby5FQUdBSU46CiAgICAg
ICAgICAgICAgICBzdGF0c1syXSArPSAxCiAgICAgICAgICAgIGVsc2U6CiAgICAgICAgICAgICAg
ICBzdGF0c1szXSArPSAxCiAgICAgICAgICAgICAgICBwcmludChmJ1dvcmtlciB7b3MuZ2V0cGlk
KCl9OiB7ZXhjfScsIGZpbGU9c3lzLnN0ZGVyciwgZmx1c2g9VHJ1ZSkKICAgICAgICAgICAgICAg
IHN0b3Auc2V0KCkKICAgICAgICBlbGFwc2VkID0gdGltZS5tb25vdG9uaWNfbnMoKSAtIGJlZ2Fu
CiAgICAgICAgc3RhdHNbMF0gKz0gMQogICAgICAgIHN0YXRzWzRdICs9IGVsYXBzZWQKICAgICAg
ICBzdGF0c1s1XSA9IG1heChzdGF0c1s1XSwgZWxhcHNlZCkKCgpkZWYgcnVuKGFyZ3MpOgogICAg
Y2hlY2tfaG9zdCgpCiAgICBpZiBub3QgQ0dST1VQLmlzX2RpcigpOgogICAgICAgIHJhaXNlIFJ1
bnRpbWVFcnJvcignUnVuIHByZXBhcmUgZmlyc3QuJykKICAgIGlmICdtZW1vcnknIG5vdCBpbiAo
Q0dST1VQIC8gJ2Nncm91cC5zdWJ0cmVlX2NvbnRyb2wnKS5yZWFkX3RleHQoKS5zcGxpdCgpOgog
ICAgICAgIHJhaXNlIFJ1bnRpbWVFcnJvcignVGhlIHRlc3QgY2dyb3VwIG1lbW9yeSBjb250cm9s
bGVyIGlzIGRpc2FibGVkLicpCiAgICBjb3VudCA9IHN1bShwLmlzX2RpcigpIGZvciBwIGluIENH
Uk9VUC5pdGVyZGlyKCkpCiAgICBpZiBub3QgY291bnQ6CiAgICAgICAgcmFpc2UgUnVudGltZUVy
cm9yKCdUaGUgdGVzdCBjZ3JvdXAgcG9wdWxhdGlvbiBpcyBlbXB0eS4nKQogICAgY3R4ID0gbXAu
Z2V0X2NvbnRleHQoJ2ZvcmsnKQogICAgc3RhcnQsIHN0b3AgPSBjdHguRXZlbnQoKSwgY3R4LkV2
ZW50KCkKICAgICMgT25lIHdyaXRlciBwZXIgcm93OiBjb21wbGV0ZWQsIHN1Y2Nlc3MsIEVBR0FJ
TiwgZXJyb3JzLCB0b3RhbF9ucywgbWF4X25zLgogICAgc3RhdHMgPSBbY3R4LkFycmF5KCdRJywg
NiwgbG9jaz1GYWxzZSkgZm9yIF8gaW4gcmFuZ2UoYXJncy53b3JrZXJzKV0KICAgIHJlcXVlc3Qg
PSBmJ3thcmdzLnJlY2xhaW1fbWlifU0gc3dhcHBpbmVzcz0wXG4nLmVuY29kZSgpCiAgICBjaGls
ZHJlbiA9IFtdCiAgICBpbnRlcnJ1cHRlZCA9IEZhbHNlCgogICAgZGVmIHJlcXVlc3Rfc3RvcChz
aWdudW0sIGZyYW1lKToKICAgICAgICAjIFNldHRpbmcgYW4gRXZlbnQgaGVyZSBjb3VsZCBkZWFk
bG9jayBpZiB0aGUgc2lnbmFsIGludGVycnVwdGVkIGl0cyBsb2NrLgogICAgICAgIG5vbmxvY2Fs
IGludGVycnVwdGVkCiAgICAgICAgaW50ZXJydXB0ZWQgPSBUcnVlCgogICAgb2xkX2hhbmRsZXJz
ID0ge3NpZzogc2lnbmFsLnNpZ25hbChzaWcsIHJlcXVlc3Rfc3RvcCkKICAgICAgICAgICAgICAg
ICAgICBmb3Igc2lnIGluIChzaWduYWwuU0lHSU5ULCBzaWduYWwuU0lHVEVSTSl9CiAgICB0cnk6
CiAgICAgICAgZm9yIHJvdyBpbiBzdGF0czoKICAgICAgICAgICAgY2hpbGQgPSBjdHguUHJvY2Vz
cyh0YXJnZXQ9cmVjbGFpbV93b3JrZXIsIGFyZ3M9KHJlcXVlc3QsIHN0YXJ0LCBzdG9wLCByb3cp
KQogICAgICAgICAgICBjaGlsZC5zdGFydCgpCiAgICAgICAgICAgIGNoaWxkcmVuLmFwcGVuZChj
aGlsZCkKICAgICAgICBwcmludChmJ1J1bm5pbmcge2FyZ3Mud29ya2Vyc30gd29ya2VycyB3aXRo
IHtjb3VudH0gY2dyb3VwczsgJwogICAgICAgICAgICAgIGYne2FyZ3MucmVjbGFpbV9taWJ9IE1p
QiBwZXIgcmVxdWVzdCcsIGZsdXNoPVRydWUpCiAgICAgICAgYmVnYW4gPSB0aW1lLm1vbm90b25p
YygpCiAgICAgICAgbmV4dF9wcmludCA9IGJlZ2FuICsgNQogICAgICAgIHN0b3BfYXQgPSBOb25l
CiAgICAgICAgd2FybmVkID0gRmFsc2UKICAgICAgICBzdGFydC5zZXQoKQogICAgICAgIHdoaWxl
IGFueShjaGlsZC5pc19hbGl2ZSgpIGZvciBjaGlsZCBpbiBjaGlsZHJlbik6CiAgICAgICAgICAg
IG5vdyA9IHRpbWUubW9ub3RvbmljKCkKICAgICAgICAgICAgZmFpbGVkID0gYW55KGNoaWxkLmV4
aXRjb2RlIG5vdCBpbiAoTm9uZSwgMCkgZm9yIGNoaWxkIGluIGNoaWxkcmVuKQogICAgICAgICAg
ICBpZiBpbnRlcnJ1cHRlZCBvciBmYWlsZWQgb3Igbm93IC0gYmVnYW4gPj0gYXJncy5kdXJhdGlv
bjoKICAgICAgICAgICAgICAgIHN0b3Auc2V0KCkKICAgICAgICAgICAgaWYgbm93ID49IG5leHRf
cHJpbnQ6CiAgICAgICAgICAgICAgICBwcmludChmJ3tub3cgLSBiZWdhbjouMWZ9czoge3N1bShz
WzBdIGZvciBzIGluIHN0YXRzKX0gJwogICAgICAgICAgICAgICAgICAgICAgJ2NvbXBsZXRlZCBy
ZXF1ZXN0cycsIGZsdXNoPVRydWUpCiAgICAgICAgICAgICAgICBuZXh0X3ByaW50ID0gbm93ICsg
NQogICAgICAgICAgICBpZiBzdG9wLmlzX3NldCgpIGFuZCBzdG9wX2F0IGlzIE5vbmU6CiAgICAg
ICAgICAgICAgICBzdG9wX2F0ID0gbm93CiAgICAgICAgICAgIGlmIHN0b3BfYXQgaXMgbm90IE5v
bmUgYW5kIG5vdyAtIHN0b3BfYXQgPiA1IGFuZCBub3Qgd2FybmVkOgogICAgICAgICAgICAgICAg
cHJpbnQoJ1N0b3AgcmVxdWVzdGVkOyB3YWl0aW5nIGZvciBpbi1mbGlnaHQgcmVjbGFpbSBjYWxs
cy4nLCBmbHVzaD1UcnVlKQogICAgICAgICAgICAgICAgd2FybmVkID0gVHJ1ZQogICAgICAgICAg
ICB0aW1lLnNsZWVwKDAuMikKICAgICAgICBlbGFwc2VkID0gdGltZS5tb25vdG9uaWMoKSAtIGJl
Z2FuCiAgICBmaW5hbGx5OgogICAgICAgIHN0b3Auc2V0KCkKICAgICAgICBzdGFydC5zZXQoKQog
ICAgICAgIGZvciBjaGlsZCBpbiBjaGlsZHJlbjoKICAgICAgICAgICAgY2hpbGQuam9pbigpCiAg
ICAgICAgZm9yIHNpZywgaGFuZGxlciBpbiBvbGRfaGFuZGxlcnMuaXRlbXMoKToKICAgICAgICAg
ICAgc2lnbmFsLnNpZ25hbChzaWcsIGhhbmRsZXIpCgogICAgY29tcGxldGVkLCBzdWNjZXNzLCBl
YWdhaW4sIGVycm9ycywgdG90YWxfbnMgPSAoCiAgICAgICAgc3VtKHJvd1tpXSBmb3Igcm93IGlu
IHN0YXRzKSBmb3IgaSBpbiByYW5nZSg1KSkKICAgIG1heF9ucyA9IG1heChyb3dbNV0gZm9yIHJv
dyBpbiBzdGF0cykKICAgIHByaW50KGYnQ29tcGxldGVkOiB7Y29tcGxldGVkfSAoc3VjY2Vzczog
e3N1Y2Nlc3N9LCBFQUdBSU46IHtlYWdhaW59LCBlcnJvcnM6IHtlcnJvcnN9KScpCiAgICBwcmlu
dChmJ0VsYXBzZWQ6IHtlbGFwc2VkOi4yZn0gczsgcmVxdWVzdHMvczoge2NvbXBsZXRlZCAvIGVs
YXBzZWQ6LjJmfScpCiAgICBpZiBjb21wbGV0ZWQ6CiAgICAgICAgcHJpbnQoZidMYXRlbmN5OiBt
ZWFuIHt0b3RhbF9ucyAvIGNvbXBsZXRlZCAvIDFlNjouMmZ9IG1zOyAnCiAgICAgICAgICAgICAg
ZidtYXgge21heF9ucyAvIDFlNjouMmZ9IG1zJykKICAgIGlmIGVycm9ycyBvciBhbnkoY2hpbGQu
ZXhpdGNvZGUgIT0gMCBmb3IgY2hpbGQgaW4gY2hpbGRyZW4pOgogICAgICAgIHJhaXNlIFJ1bnRp
bWVFcnJvcignQSByZWNsYWltIHdvcmtlciBmYWlsZWQuJykKICAgIGlmIGludGVycnVwdGVkOgog
ICAgICAgIHJldHVybiAxMzAKICAgIHJldHVybiAwCgoKZGVmIHBvc2l0aXZlKHZhbHVlKToKICAg
IG4gPSBpbnQodmFsdWUpCiAgICBpZiBuIDw9IDA6CiAgICAgICAgcmFpc2UgYXJncGFyc2UuQXJn
dW1lbnRUeXBlRXJyb3IoJ011c3QgYmUgcG9zaXRpdmUuJykKICAgIHJldHVybiBuCgoKZGVmIG1h
aW4oKToKICAgIHBhcnNlciA9IGFyZ3BhcnNlLkFyZ3VtZW50UGFyc2VyKGRlc2NyaXB0aW9uPV9f
ZG9jX18sCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBmb3JtYXR0ZXJfY2xh
c3M9YXJncGFyc2UuUmF3RGVzY3JpcHRpb25IZWxwRm9ybWF0dGVyKQogICAgY29tbWFuZHMgPSBw
YXJzZXIuYWRkX3N1YnBhcnNlcnMoZGVzdD0nY29tbWFuZCcsIHJlcXVpcmVkPVRydWUpCiAgICBw
ID0gY29tbWFuZHMuYWRkX3BhcnNlcigncHJlcGFyZScsIGhlbHA9J2NyZWF0ZSBlbXB0eSBsaXZl
IGNncm91cHMnKQogICAgcC5hZGRfYXJndW1lbnQoJy0tbGl2ZScsIHR5cGU9cG9zaXRpdmUsIGRl
ZmF1bHQ9MTAwMCkKICAgIHAgPSBjb21tYW5kcy5hZGRfcGFyc2VyKCdydW4nLCBoZWxwPSdpc3N1
ZSBjb25jdXJyZW50IGhvc3Qtcm9vdCByZWNsYWltIHJlcXVlc3RzJykKICAgIHAuYWRkX2FyZ3Vt
ZW50KCctLXdvcmtlcnMnLCB0eXBlPXBvc2l0aXZlLCBkZWZhdWx0PTgpCiAgICBwLmFkZF9hcmd1
bWVudCgnLS1kdXJhdGlvbicsIHR5cGU9cG9zaXRpdmUsIGRlZmF1bHQ9NjAsIGhlbHA9J3NlY29u
ZHMgdW50aWwgc3RvcCByZXF1ZXN0JykKICAgIHAuYWRkX2FyZ3VtZW50KCctLXJlY2xhaW0tbWli
JywgdHlwZT1wb3NpdGl2ZSwgZGVmYXVsdD0xMDI0KQogICAgY29tbWFuZHMuYWRkX3BhcnNlcign
Y2xlYW51cCcsIGhlbHA9J3JlbW92ZSB0ZXN0IGNncm91cHMnKQogICAgYXJncyA9IHBhcnNlci5w
YXJzZV9hcmdzKCkKICAgIGlmIGFyZ3MuY29tbWFuZCA9PSAncHJlcGFyZSc6CiAgICAgICAgcHJl
cGFyZShhcmdzLmxpdmUpCiAgICBlbGlmIGFyZ3MuY29tbWFuZCA9PSAncnVuJzoKICAgICAgICBy
ZXR1cm4gcnVuKGFyZ3MpCiAgICBlbHNlOgogICAgICAgIGNsZWFudXAoKQogICAgcmV0dXJuIDAK
CgppZiBfX25hbWVfXyA9PSAnX19tYWluX18nOgogICAgdHJ5OgogICAgICAgIHN5cy5leGl0KG1h
aW4oKSkKICAgIGV4Y2VwdCBLZXlib2FyZEludGVycnVwdDoKICAgICAgICBzeXMuZXhpdCgxMzAp
CiAgICBleGNlcHQgKE9TRXJyb3IsIFJ1bnRpbWVFcnJvciwgVmFsdWVFcnJvcikgYXMgZXhjOgog
ICAgICAgIHByaW50KGYnRXJyb3I6IHtleGN9JywgZmlsZT1zeXMuc3RkZXJyKQogICAgICAgIHN5
cy5leGl0KDEpCg==
--000000000000b450f30660f17354--

