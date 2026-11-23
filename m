Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AAD9606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=W09NIKTa
Received: by kanga.kvack.org (Postfix)
	id 8C2E16B05B0; Mon, 23 Nov 2026 08:13:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870516B05B1; Mon, 23 Nov 2026 08:13:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75F896B05B2; Mon, 23 Nov 2026 08:13:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 439426B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:13:30 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B832DA8591
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:13:29 +0000 (UTC)
X-FDA: 85466425338.01.7A7F6BC
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4D9F040005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:13:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=W09NIKTa;
	dmarc=pass (policy=reject) header.from=ionos.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795439607;
	b=YRkXMVw5mDHjOtQQKZRFim5pZvyWFlW6xrbuv3kOnq7Vs1sz2mFHP+5nvE/vnQl14eftB7
	X9WJO1fY8+ArVV8uVtiBc6/6uONTixjsY2o0cA4AZPzw7orJis1dd2bq9PZwBx/g2yjKdO
	4C/chF3YDAdktH85by6vRM6nilc29qQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795439607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQb6g9BiZ4ZosTHX5re+WDuvLyIDAspwcbz+If1/Czw=;
	b=gvvZ4G+UGWooD6z1upN8p2FfYoB+WQkpZhS1NzAt55osmU9rNiFvDV/YBBYqPcQ5neB05g
	iBQ1Ee6lojrJxxOlD+QZ3My2WN2NmF1RUsrlsS3wp5/cg7uD2g+1O0vMkZ7/iB/LvxXUNc
	oR405otuRt5B66d//UtT/zBsLUtGY4k=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=W09NIKTa;
	dmarc=pass (policy=reject) header.from=ionos.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c516a194350so145183866b.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:13:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795439606; cv=none;
        d=google.com; s=arc-20260327;
        b=ESkPONV6wLw5T61XvaiguF3Me1H55pJ7K9edtPTSWaJKxNU51ey9ZiLU2IcKB0fy7d
         Fs5MdfYjoA30RssV2Jpp3WrYaeiJfl7ga3r07fRb/gAMhW9/dHxuc7BS6o/4UzsjUcMG
         qVsgeHOn96uczv7RJlpMUXi5QjJBMLqROisRDCKqKxvVt+LV09/ZRWo6CT4THo9s5SAT
         3b+HLcaHf+tQH8lQB4qq2eyHMm+3Sak1dG+sB/OLtqZS5mDKDeZEvGGAmHJnX+c7vGrb
         kvZFUbJPoulbq7GEUWzqEaXsp0jxbDexKC0vnGyS9+roL9J+IYsYeW5teglw9iw6oJ91
         cS5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tQb6g9BiZ4ZosTHX5re+WDuvLyIDAspwcbz+If1/Czw=;
        fh=xvN1bGdXwkVsJJEu0MToD2XOmu5Oldqa/M3Yf82isyU=;
        b=WeD2UYeHhWiVd27CXnjBOcpoy3ptL14xCozIbLRgbtKAqaVkPnfP6U6adkNZEW5x2G
         rryvZcZR5oLfFpNI6sk4Vb5sY21qljXIA916I+giNvJnALBfCO4Zmy2/I8GYnics3Al2
         7P2JRgo3L3bNykdGBMEwPsuPqZhSlUyvhn/9L1mfGcMiTbegh+n2nRZNIzbSgtPOiRQb
         Z0X4I+YpC1SIIHjDjzjUrm44c+mVbC9nd/SbdjlYDtTjxUeX0U38q5bpgm0OZzMFfYy1
         u/s11WUnNi2aj8B2snZAiHMOmn2vNHSAVGLFGwZGKNgGawozZUrmgC4YRJE+KD2lTEU+
         ye2w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1795439606; x=1796044406; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tQb6g9BiZ4ZosTHX5re+WDuvLyIDAspwcbz+If1/Czw=;
        b=W09NIKTa51+pTv5+5MonCCosQh0NeHgQArlJ57gRu09h6uh2/qiUKafC7hXI8H1rHu
         PuOfqyLtwrfJFkLzBz0h6pRncugYhjDREId4L19nyB4E6JhqVxzG3QcVuwNa7IVTGFAT
         S76OoON+NN6tEfzxCK83oBax1zKZ2RxJFfPAzwwH3ZrYI+SPDCUzstS3bevPdbUsz07/
         pb7ETa+RsIiQCqzAYDHz0NnC9KfwuPpODEkhp6kDc24zAlgs5yC7BYCPCbPNlpMUVbYD
         WJh40sZNNOvMQIP57Ntwp4+Lh7CSnnOSCXptAJBZKeL+0l4UtGzBSMRaNG5Y7TC+3VIw
         BZwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795439606; x=1796044406;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tQb6g9BiZ4ZosTHX5re+WDuvLyIDAspwcbz+If1/Czw=;
        b=HUACwq5gjCwPULCxhrK9vRAQBIxKo2IACUO/3vr9ysOhE4ge/1knNqc6gVFciMcLXn
         eZ4zycH6s9oCgRybneFupv3xoL/Zrwq6TZWozH3LVX3zaZT4vOuhoYw6pvuc82Ya5ORU
         QE6+576jM6wywEF60AfDj2UQKuo/Y0BbmBWP6DLa11L/gzjXHfjPRtIh+cNAs6zDOFwB
         XdCom///2GKI/GyhwJyHxVqHxA1UP/if/5svqSpRmrdJhZbOcOFXXGJbEtf0UfALFJSL
         lX8JyOmwuwFBvZdxm8EjSVoTfo5Frcj+Qf7p6XWtOYqYdKLSXcAn/yAV+RmWrlBRCQY9
         i8rA==
X-Forwarded-Encrypted: i=1; AL+hErGz5egzF6XB0QwD7Mi/1SuVBDb1qXAVX9G2FW6UjCVDLxnHnPZOQPxFLTXjCnTcBgNjuX9PraBQ+w==@kvack.org
X-Gm-Message-State: APuU4Z+uSmqUjoXZCJy/c47BcCeXOWckIsjiNgtk7ZRcUFNCLPNXXc/3
	ycVwYV4jTzQxT/urHlfVmf+oKC66+Mrm2pPV8q3aEOqz1zjR/kmUQx8JB3OIcdByy+q0c1IAdt4
	QfZJ7sTExrEUmkaTSJvztZH5kL+wJSff/C/ogdlU1uA==
X-Gm-Gg: AZFdTZdhb5W5xKFxge7ZwQJEnrsBJTA/amATpfhY1dOZL0jlQw3a1uPg1ZHRuQjyFFI
	npPVTt9hCm1jdO3WIuobmNFXywhm7u5Yrq+bZ/m6a/pXIXaObQUbgDrRVhyEiqmGnZiMxJ693n6
	/UKaVSmEVXcSSJgQPm2rUfvWnUlO36zbTHJHwoheoPHZlLdQ6tXbM75IIcWMBjczXTcKCpxJfGN
	8KDZXJdrQHh+OD1sPGA26/kLgoZYjXzGuQiQYge91ffjU2Hj/KdkD855gCjyM2+2NR/HEXVjZUt
	bQoohy783xJrfFe9DSBqaEMLllExoxOZdJaCfwFF3kcwwfA6DbMfk4jkm8KEg2fo3kHmnK/bOJn
	bfbObKl23WG7GnfugvB947eHnZ6sFr8wGPfDZ0h+J5CLYL2Yc590dOLjiggKFoPB4Kg==
X-Received: by 2002:a17:906:5453:b0:c50:5a51:632f with SMTP id
 a640c23a62f3a-c513aabad57mr752927566b.39.1795439605669; Mon, 23 Nov 2026
 05:13:25 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116081403.216452-1-max.kellermann@ionos.com>
 <20261116081403.216452-5-max.kellermann@ionos.com> <CAGsJ_4w3cP+tgCGhTFu5p27Wi-9AFCneQgwLUAUg7X-gvX=e4Q@mail.gmail.com>
In-Reply-To: <CAGsJ_4w3cP+tgCGhTFu5p27Wi-9AFCneQgwLUAUg7X-gvX=e4Q@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 23 Nov 2026 14:13:11 +0100
X-Gm-Features: Aa3M54qkAN-FUxtSPdh9O8Qt6TQF6J4MfIqPGFS6SuLOsMmm0mfMW-dt_mgEmPk
Message-ID: <CAKPOu+-Pzp-ovWNq394yBD0Qa5zCLZjx=sE3ixLs+WLf4EgZBw@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] mm/mglru: avoid redundant rotations of young memcgs
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4D9F040005
X-Rspam-User:
X-Stat-Signature: kjifdqk9tcdat5wktspci9s188kyq6in
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795439607-673701
X-HE-Meta: U2FsdGVkX1/VT2zD1TTVc3oCMrMJAUA2uTW0woIkCVJrXSSfwmbWAZZvTojglnPgpma85l/C1NwDWDk5dvMXA6Chps1e3OjaCMIuIIscjktja4p6Za/zoOrCYsvkgp0G4gwxgoNYK7VD+t6ueUnjUtXF080YjM9t0GYKUmZeQ//SZPRtVbYvIv678v7Dy8tNs+TdqdItR74JE/aXLa6nVv5hqPuYmCaQ/h7uZaNbyVkyOWAjl4z6vItbCMXbc+wYZo8G4cGxN61/HGrxLvNsl1i/DgxJmSQBtZaDDiA6KqMdEmC2jehPaxo8sMiH4EJptXfz7bKHxMpAIhB+H27SVoIVkgFIMHGbSgre44r3jZPK0NnnndRhSNt/6WNZlbQo1FF4mVFYh4FwSpmQnv41HpNbCf8Gl7Gfhm64tw30xLcVn14JqWlO664h5nu2uKswFSee3PYY4PUkNjV3keRsL05j7iUiLJssycmxymi1FJm2lSov05bJaHcoSpahChPcvGd/QWMVId3tJ1I8EEoku4nEctxTZgyp8pjaZr0sa+MbrF/0SbaFUokUV4ciCXmO4dV8Gdg7Jt1Ja+E9YnruWM9iRcVddh+jujDPCpVW72viprqzx76h1rWlAsB17qLu7tbaN5lmP9NH/UQo3APSbCwqQD7OplaSwG04vRAIOeWH4TQ+TcJ5dlKNhQjbIljtQ4BKbIW1My7PHT6cyMPIyYGCBw+cr3x+GKjEGnJ7S0dvOBUSJNN9FZ2pixbKllHIYVWB0sxXZYzDhH/TpsaDk8iqTXDaHP5F4rDN9ai1/bGeE0RqU/LE1tA8j7Je4WuAKRr1UhYxtbxtCCdWXrcLbymNQTmSRfthne1oEfX4uUefG1xO/2VQpBus7PKfhUtT0ba7Y+hky4dATIow+9azalWiihqDAIiaRduWtq8LH+sUovBaOOsIQZ9MP9oruJipoB5hrfI9rbv8xuu2e2U
 u7dOJoQm
 q/aDqXoQBXATsv0HO5CYLgUQKgBghcfwlrOMtRcGZYhBvJpW8mo/aHxf9hMF93gxzXqb9MPFKJLLX2nKejQPrCI3W8BwNfeafK/VXCzZunLK2ZdXJy5ME7J8rbv61h7aHYE+KPV4IrHOpan0F5+7rzeLb7EuvEhKaNkNrKP3VzFABgJbUeNERy1pH0554+DRRypiKkIGUx/fBkIn+oe35QH0Kt2qdfJWsU34j4OjZ6zm+BF6B/sZoYFUxiOsu2GHKr4izYIWvroGv/iiRyuGY73xd3fscBG2uYytZgKZ7sKjEslnDnz1/Zt3083nbOKGzH+bzaGqjp2GQDu64vOffc9FADY8tvUizKMcRqWhesrkrdFv9dQ1bwHovN+IpooeNGPGjeggPMMu3ikHPfxhWHAliuTPDhHbVSqPqEIMlZ1bjFtTiPgqx36drYkl5A3v6RbzFLqGs/aMUJYpir2m4rb8RdMpdJPgjPv2KaJU/rpU/wRd/rAMIjCYrQRJ0BfLfJK4YRO4dSoayFpud/rCs3BDeOElXZfFcsWCQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 3:01=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
> I know it was my suggestion to avoid unnecessary calls to
> get_random_u32_below() unless we actually need them.
>
> You then pointed out that this would move get_random_u32_below()
> inside the spinlock, which I had overlooked. Sorry about that.
>
> Have you tested whether calling get_random_u32_below() under the
> spinlock increases lock contention?

Yes, indeed it makes a big difference.

My initial version which always called get_random_u32_below() at the
beginning of lru_gen_rotate_memcg(), prior to locking
pgdat->memcg_lru.lock (but some of these "bin" values would never be
used with this patch):

                  &pgdat->memcg_lru.lock:     103487653      103501074
          0.06         301.90   195317628.84           1.89
113777275      116290184           0.04         339.54    30052760.20
         0.26

 Completed: 681 (success: 1, EAGAIN: 680, errors: 0)
 Elapsed: 61.23 s; requests/s: 11.12
 Latency: mean 713.05 ms; max 7470.24 ms

With the get_random_u32_below() call moved inside the lock, however
only called when it's really needed:

                  &pgdat->memcg_lru.lock:      99442644       99458122
          0.05         342.95   243043664.06           2.44
102985677      104642320           0.05         231.58    34095676.89
         0.33

 Completed: 548 (success: 0, EAGAIN: 548, errors: 0)
 Elapsed: 60.66 s; requests/s: 9.03
 Latency: mean 880.18 ms; max 3847.24 ms

I did a few runs, and while there was a lot of noise, but the
difference is real and reproducible.  Surprises me, I wouldn't have
thought this would be measurable.

I guess I'll move the call back out of the lock section?

--=20
Max Kellermann
Principal Architect
Hosting Technology

cm4all | Im Mediapark 6a | 50670 K=C3=B6ln | Germany
General information about the company can be found here:
https://www.cm4all.com/impressum
A member of the IONOS Group

