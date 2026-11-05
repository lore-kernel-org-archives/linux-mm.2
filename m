Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18888606A32D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 259AE6B05BE; Thu,  5 Nov 2026 05:01:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20AE86B05BF; Thu,  5 Nov 2026 05:01:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 109226B05C0; Thu,  5 Nov 2026 05:01:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC57E6B05BE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:01:52 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80E8EA09C6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:01:52 +0000 (UTC)
X-FDA: 85400624064.26.1A1F7FD
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 90EE7140007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:01:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793872910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LrgDMUrSYXpYgkAhfsYKg0ebb/uLgOfOMhqzX4yL0j4=;
	b=JoAWJAUqZhBJ/DXMFKx7uI7ZgzuXakJlbD1jw1wrKaqDH5nZ1q25mL4BshZxa8EjMIPxUY
	MayQM45vaGRJDJsIzIqinV6mWPY5Hb4j11dkcT78uGrvK32k9PD7mpkL+0c2vJkYEsU09r
	4M4qYzFKz6imYMCZ/TmLoXsgTNIkMK8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793872910;
	b=Ldy5wEhE0keHUyLUVTrLnSxvmRuR5a7QA2HntHN73Gq5ibsdALgKLDLTUPrs0PrAZbNNon
	BjovGD56meFH6i5iT5woZWR65DEGArIxkb0VsA4Vi58iVojxxngqNA6K0KrqEZFHQjbmPm
	ifXl5PLZxks+26fiIdutQbD28Xyeq+Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com;
	dmarc=none
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93e7ad9f78dso201291285a.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 02:01:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872910; x=1794477710;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LrgDMUrSYXpYgkAhfsYKg0ebb/uLgOfOMhqzX4yL0j4=;
        b=fIJ7m2vHdcEe2djXKOpdmnqErJ7sxIf14JaXiET/mKfqcYOsoJlYa4qo8m+tyRnREg
         Uhr9SPkBLPD22c0QbF7am4Itx6Ea3t39DUITpAXkjzbmXLqlHitfSo/qUMLlUY7IDCNh
         cjO2mL/PytRRcX9dTSz78gbvJI+vi4pQ9TSBHXQIlLBHQjPzLA7NUfKF1PKOMRu19c3L
         gC01BE7BpuUaPk4GP0JYylH/WfQZUYUPQ+iEX5PUeABThkUkbzqkTG41zOawXflTyx0a
         ohfzzDdWewUKXr7B6X+MAdrz5JR+xti2Vh06RIkA92KRMp7GJhnFkK7nH4EGvWt0GUlC
         sN5Q==
X-Forwarded-Encrypted: i=1; AKwUvBxcUHppPEyIgs0w6YaLt51FB4/R9/ZpuDmFwqld46TOzsDTt2Pp6OWcAhhEUu0LKwZf1fflhPkqXw==@kvack.org
X-Gm-Message-State: APuU4Z9DRxHT9KjQhuhaQ4UvJH6UEvRMEO8l0/++arlZ2Fw3Jn/TiKcO
	A7nq5YNN7z7s+EgqGoaFWKj+irzDIEjswVJVUfPIvqt5wLvSY2A7HLOenPOhLkSDEFk=
X-Gm-Gg: AYBFou3CXf/3NYgbNwfYD7AgpxAqse5xfL05R+vHm5NcuEwtGEuP8nbnY0U3/cq18Fg
	BuQVPzd2m76otto1xd2/3arSTVctiYtNz9oxpRnjB6Rj8WTJIwWwbM/F7Mcwvz/Thgcwa/aWajZ
	l5y3jMbgY1k5vmMIaO1l2ffhaqex0BabNElmhzTN+6RqUGMLzRmGBWna9cLmOsSdpt7H0nmpEyB
	AciWibUqSfj7psc81j/2vRy8xM1nEOcIEkESZhGJxuN3AwJ+ZirdXaTHO84yvALf3RM4DSEdYAX
	zxknRfu513y6/39pEr6JTAmpLe88y9FUMrUNyRMYV4BLjt1VKiSY21fADH48U61aLxqL9x3aAA3
	2TommaUpkXE2C+ZPbV1PFz7iBR4TLUx6ub0eeS9MPDIS6yg3tPgsZbiqWExMiKVQNYRTCKIGNMk
	MR2K9cZdvMxa8926PwSB/1fYscCiw7b6LJ7p6yot+f05gr8O/6xjzjVObZcuoHjK6ZXP61a1Aaj
	EKnBTwBuepCKdvoEZ0gfJ1XX/QlWIlPkIe08otpJ50yTlJbnfsWtalRiM4yg74Xj8D1KEfYudlb
	e6PcCeLyBEoJ6PU9fWO0Wgts/Vt5e+aDXa/QwNn7ZAabPZzr1bauqLupvq3RuJ/Yiy/NFw==
X-Received: by 2002:a05:620a:4147:b0:93f:23ef:d6ad with SMTP id af79cd13be357-9442140a71dmr3247185385a.0.1793872909753;
        Thu, 05 Nov 2026 02:01:49 -0800 (PST)
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com. [209.85.160.170])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-945d488f183sm426631785a.39.2026.11.05.02.01.49
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 02:01:49 -0800 (PST)
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5364042eecfso22727701cf.2
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 02:01:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzxKKDPNj8HfSeA93zEM28FL7MviMEPst6xR8xs3yygpT6pqh2rfAKki0/seYtGcNRgm8rq8JrK4A==@kvack.org
X-Received: by 2002:a05:6102:5108:b0:7cc:56a:58e5 with SMTP id
 ada2fe7eead31-7d072d84a58mr8269567137.37.1793872526219; Thu, 05 Nov 2026
 01:55:26 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org> <20261104-work-procfs-drivers-v2-2-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-2-245e54e87116@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 10:55:15 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVHxQvKnJyKHrOZhaOg9Rn2hMeRU1JnMFFEEi31FPZaGg@mail.gmail.com>
X-Gm-Features: AclHuK_UsJ1nGicdWEWcMLQAICTi1A7pGF3yhNkxXkXRPqohle17eXAHHNBsR6k
Message-ID: <CAMuHMdVHxQvKnJyKHrOZhaOg9Rn2hMeRU1JnMFFEEi31FPZaGg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 02/26] zorro: let procfs copy out reads
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, 
	Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net, 
	jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, 
	samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 90EE7140007
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 86ky1sgizxdyig6hpouzhx6z3ui5zxmc
X-Rspam-User: 
X-HE-Tag: 1793872910-534437
X-HE-Meta: U2FsdGVkX195QSzMN54lZm2hfyBlNWEZUxAh2vJeSEkdeiaoiKMNaZhRGHjULJgg9wm2EdAzNDbNnW2vjjao0zRI5JQ2kL1I7mta8lAXTskN6iSPEx4O2/ta88JTorRovhbPlBOMrLMibsVm9/h89Do3/bK67MYjF/41jRtmaJFgKKoFektxJhbSGnTm+NNhYWa7tj/uyylTpolGwCPqRM9KKfpa1zrFUMKIYcbPC/sCHri7L4QhyxN8KVigEHFAp+8xVoiFPvVYfca9ycTv0xvmt+anGVtvHX2JQh6U5P91jc9SYuQFgFP/RvMsdDFYnFhspGZsWadqoZeoRX1QPC6DPgEMNjFKW9qy1BEghTl/yCBIEOqtNu+dsaVC8fQeAjT5u8JHSTBsxFyU9S27G4E0t4uojaQOdwlNSGaPpracYS5PsK8Mp8VRCIQMpk8YWH4UzPwtNvZuQ0UXkv1qgAg70CXn6RFYpVpfT1IhCkVjUmdUEmPx5br5lz45g6PS16pbv8+zHZwYxR6fre3ptRQL0VR/Si5wSZHDoCxmLrUEcxuAOcthB3NiDBzjHY9deAzKfKCCwU0a2QQsY3itfRC9rvi0lfgAtky5lA4DtNp1vovvXtlpWCHP8AtTlSxfNYrMado7JT3sLlFoNDw+EBNTafchX41tNZwT7gsQOd7CntUhE8HKwZjUaptcgoQifXFpok/N/awdgeQrFThUYJP7rR0m0RV4rVEerkKSDXNoe+tYeLPK3hgbsIomhwjQig8E3rSABCHowM63Jn6lLLsXIKVHyCjCr57mLAP2a9TnMbmBLsdKorr1VvRa/YmAsmofg1R0y8b0qp7Os6+3GRnTofUarqVCKv2PLmjr4MX24KZnxz6vzFjrvC4xWxykyctYzuknHvVEfqLW7a3h1zH0LajS/0S5srxZozkyZj3AtixoyXj+YG6Sk4yEf/vom0iph6a8blde7gBgLOl
 n5pyrgnM
 M8Ky3iZytC+jzQvAG8mlD97ArYwV25bsPVMmC9tjzV9pAnf/QplRvhHf6smH1U0UlhPM7dWE16yFVe3aptYhhYNY63KCJ6DfVxeri4ax5qi6V+epBtj8om7GNObbEGO1SlOSufce340Nc88ldnNE7JN3mcwvuu8anB64VtLhm35aCl0LHai8ydfsksOSdEMRju70W6zeOFDmgMffNaKr0qkZ36Hikz61vPILqpggYHU3ch9kmnhPd5H4GxRCMBJOJ3c/7KA3xvWCVqVxmkUjVfylVdElmviwe+gB2Jfib48bg6I+xOt0o+hX35oN++oIVprL7r7lLL38HIXn/0jtmBMorOsyKlgk8xR+h5HVl9CIA362wpYxMIZ/NDYHW3d5muAf8kXyMNygSfZDH+1BAmjGz3ygmuelW4l3UfkqoxR7+f4rvkv10SAHpwE1GwU2M3/km3FS/AmlUDVDYhiaIfUe5YcPrNO2QtlS8WHNWmuv9pTRdLyFw0Gc/WyLc4ukpkse9PRnWcyIqCiaFJouIaeA2ODtqsfYNYYhPBvN86ox0qzHtwzP2naKfy4EnKOc+MgQZJHFAsU5ZnKUhSETYFtjh7kP7jfJBEiNaNRLU4+CdB0LtYIUndYi6euggrON+b7mX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 4 Nov 2026 at 20:43, Christian Brauner <brauner@kernel.org> wrote:
> Implement ->proc_read_buf() so procfs copies what is read from
> /proc/bus/zorro/<slot> to userspace after it unpinned the entry.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

