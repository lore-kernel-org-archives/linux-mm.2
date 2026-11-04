Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E01B606EEAF
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 20:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=dLWm9cg6
Received: by kanga.kvack.org (Postfix)
	id 1FA5B6B05B0; Wed,  4 Nov 2026 15:05:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2F46B05B1; Wed,  4 Nov 2026 15:05:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8F66B05B3; Wed,  4 Nov 2026 15:05:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2ABA6B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:05:30 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44B0612080C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:05:30 +0000 (UTC)
X-FDA: 85398516420.16.E2AAEEE
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0AC93C000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:05:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=dLWm9cg6;
	spf=pass (imf10.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
	b=5sb1hL5m6EhURaSee3KT5M+dbzjvfZDS9H+y1YM+mzsCJwJmbnSUQglvMXUlu6MJroCiAS
	M2RpktsQL6+L28gTmPcKpRf5KgDgiGZxViH0S6X30P5vvP7rxZEqvuNqIXPYHH0hhA81FS
	r1RjxlVfvU5Inspx2gxP32qso773Oys=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=dLWm9cg6;
	spf=pass (imf10.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822728;
	b=zkDv99OUP7GH22j1uiCLYIUoxiug3Ihn1VLWAu2LrivYskUBRtrayV+BUAIFVPQD6X2E0H
	BEXU0QlqMHcH0k3EQktaESpzftabFVMDLJ3GDgDSvSWKpJ82E10M7zW46IC/28j96bDby4
	WxFAdzY1864PUZRIW7aZpWZc6hOJd/8=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c423b145922so162305266b.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 12:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793822726; x=1794427526; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
        b=dLWm9cg6vNJvn+20rxiZxqVQ25DP8PmxEP2s+/61XfK8PXbXYDPM8xXYVKc+Yaz6Sz
         cQ1deu5YK18/r3YzWK9cI+7N8ZdA0D0m0EJwTBTCPQK4Hllu1+z5VjmW4ZdszAbobFAs
         EVRv4HFIHAxJVgw8j3YX2ZSasAyEcZ/McfHg0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793822726; x=1794427526;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
        b=tdA9nczDEnR4MxV2w2iumW9pLxn0RuPbYgTtMD0XUfron98BKhi5g8p1PhGfCyfQUM
         l10H5A0sLRQQSOhK0N5MSYUnqUSeevVa7Y7rF1yBrS/8+hswwca0x1ZyHMGxp//NJHaR
         R7ut/zHpWxtKG491iZHQgOWBSJZKnRpdkJ5XjOaDBvc3KUzP5D4KSWGOPD6kNVN1R7Kf
         t8wknvz7XLY3vfkNbW5HM1lmo3ZahJMYsV5Tz+grymeQO4pmjv1zJKI9n9Z740IDMcP0
         Sw3tnr6lKZBWraaZL6k3NVim96TycLHNxw5Q/kFHSkbSt/wSuf/fk7f7n2I5V67DMKvc
         3JwA==
X-Forwarded-Encrypted: i=1; AKwUvBy0y8PqsrtusnWqC4BEDS4O0MLfzQFQgN8vHN2Euyef9DXzydaH2sjgFXlbXmOTs8Y3aFp/mTxkWg==@kvack.org
X-Gm-Message-State: APuU4Z8gatbW47MnFMO2Eo2eV6LfGwkp9KnulIuVfizMXIMjiFx7OgC7
	/IFcibnop+MgLhYazVzMYh8eay99/EYSFA764TQFgDyxL9SB+WYjh6weiyKTUgEvbByrCHZbaIU
	R3OOcKSeNFg==
X-Gm-Gg: AYBFou1Tn9L1g0qGD/+lz3MXSayAxdApzc4fKMM/LgHBCPo29alGk3whBNG0DftH+Cu
	hTs4x1fYazgP08rmpRcUO+SqiEB9kSczNYqTbuQ778jUt88A0uPBQTlp05MeLP8A9/aBQ25uowv
	Rc4370qPkYz0FVU9sJYinmx3nDJHu/e8MxAy0ofc7vuOa7sJ2PcMKUgFbtuyRcbDJQHlC7WAtBr
	PUnxbP4Lsu/VFtqQ1g4c1iVrSwo15eJCDG3Cv9H1XmU1E2j3N9+uEJhl3iLnAiJ+W3aIF1f0du0
	yh//1SCY28gw3of/bTMB8zWX2Bfcw2ntPm6J9TCpNax5AtbMpvEBklJqx78saSAzns4dmtDLNSh
	z7CtpVroCrffil+bWmRHvc1Sgo/VLEKIT657xchsvTBl8hHXZ6QkKP2yN/VxGWxuod9Y1lz1kg0
	vvvV2/RNunipYP8HYBfIz8Itmu6L5DBXYWeiiQokXxKA5vwNfpRA0LqwzlAzCJMnfeTvhls2um+
	HL45E6Wdn+WTEsRd/2HW7ZnAY79itedOzejLaboJ5NTvqX8SUidWJXw0lwUeGqKLB6SIoPEHqOJ
	zzvosIXomIqKF5VVMuSkTPU/tn0rdRNwRTRpEu76bWuNe7MNqRc11ydVRx5XezUWgoQr7JCa3Oa
	euA==
X-Received: by 2002:a17:907:3f1b:b0:c46:9e42:2563 with SMTP id a640c23a62f3a-c4ca7ad1d53mr1442504866b.39.1793822726271;
        Wed, 04 Nov 2026 12:05:26 -0800 (PST)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d0e48d0dcsm102634266b.70.2026.11.04.12.05.25
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 12:05:25 -0800 (PST)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c423b145922so162301066b.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 12:05:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxUAQhJdokzppaRj55w71slqOfXlqwEtGJoc4oSnJ3EaSYSx7u7OOGxy1DiiaVhH4xUdRSwWodHgQ==@kvack.org
X-Received: by 2002:a17:907:60c8:b0:c49:a4b1:9cb1 with SMTP id
 a640c23a62f3a-c4ca795fa50mr1973235866b.3.1793822725121; Wed, 04 Nov 2026
 12:05:25 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104-work-procfs-v2-0-b45cd5789ac5@brauner> <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Nov 2026 12:05:08 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj9Y9NcOesBBm+jhPjYa7qO00fD7g7uwX+H-k0-R2difA@mail.gmail.com>
X-Gm-Features: AclHuK9j_YIgrwhhpWOlnull6heAULBd4dgTqoOhUQQjFm_MgoIgrL1vgPfefvI
Message-ID: <CAHk-=wj9Y9NcOesBBm+jhPjYa7qO00fD7g7uwX+H-k0-R2difA@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 00/30] proc: convert the fs, kernel and mm
 entries (Part 5/7)
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
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
X-Stat-Signature: i5uspddqnwq4as9xnx1p9r831bp5aiaf
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0AC93C000A
X-HE-Tag: 1793822727-174151
X-HE-Meta: U2FsdGVkX19kQN/mkrPRCH9kdbaTHjprwYNZoUAY3RVwGbr8ytgIWhOVux0MlC8zZXQyGNupGVGcVikYCPknfelld1qyjB5M9/FB04/NlcEnx3OD4fkpavUad4xzlQLMPAUJwnXW1VsAS3TggHpvKkCJHEyHNZuffZSRX1ZNxOFeW9I9rSLA6F114lix69o/2OJKUB43YLEPbFj0eH1FMPlxzdXo2pYxCo8bajPIxxgADT3Us1Zu1WT5dHSNFJPunTXhH1o1dLpBH3eOE/+3IxCQGnRgmcSMplHSpmIje243ouc95YEpfCvriN331ECH5jdRzmxCjB2LfEqMriA3fI5sfXigf9A5Xf270LIbOcS8O6Ee/R6y9zptLSVPMkKHQqp5SdAzn3+vvklFu0GF8obA7WKAvCqn1+3M432lfmk0o+1PyORQ9cE+HH9p9mqJk6y8N7h5+R+XZpVqwqhxSxjJAHghkFmKhWLFgWZdsAqZ3HOlrKhYJI85tYfpInbzozr1J2wWErTbfKSIzCk56fN/+y8Vn3Z58SKej6z1Wr/+C4GRfE2OCPNFi/J/PvAhoVAVjRVN6yIWycxmZa6gZQIZPhY8pv7xgcMvx36Zz7x1kEwGS82CMl6/PARQ4kvN2y5tPaidozK0kuq3Rt1lPczZaqfOj73NpIKWGdDgP7DlGLbEoMoiTvTS1kuX6fv23BafY3MylRUMZYoDT/NjT2J7TLqaUvaYYyJDZ7rLMrlzt010pLSr0+hIGaB91ZrZ167zyEyciEQ/KI3Fvf7b83MrIZWHhD/FnNDKZTwlm74fUL2ql93RExMGXewkFI+7QUuzIxQacNvY+wihJQzIzF7bZceL5frwBr0q2teOcqvtt8TxprQq93mXoVNNJDrJEU+zFjaLtqN6788u2aYhN5sAQ/e3hJRhTfjp2djdaO034kUwuuhGr4zdzL8SHaqrFNykj77eHi9ThxpaaYj
 73pezC4J
 yagqT2C/luxLExUTKnztSHCS+Cey6UFTITjQfd9twAO1v3wOdUnxXzx4ob2EHEPGTQPMHJRyPYMK2ebavXL7E8LVbpUx/pQvTM9+SvR1d9yYed5nvow20SLSHnlZCE1YZhvFV5oRgeR0cyPuJkuggsC+LFfp4AWmzwF35v//WDDahkIu5BmPT1t4WQq5+c5fvanx4awVYOszKhzYgjdjnIQMbw8XjWUWSW6d/ZHtBkwDYosF4O5wXekFq9+1OViI/cGGwp4xv6w132XabP+5mQEhJKWuJ70aGor44UAijW0lm8ybAD83AecPKSl5g3UX4y783KeK7NWhXQRnoQMJPywW87f3YB4fRVsq43q5Nz6f9/J+yUsFk7ZyUq5iIVw5cVbLY/8eSzn5Mcmp339Oi2Z+1mSx642ufk7hW5yON3w8VHfWaVbMgAfnu1PVBBckiQXAFJVwFkfVeKo+KEHbdXM4HeX/zLuls/sE+/SrA8vlq5m2qZ+aGeODMzAUFTUXv+tXBK1nVWoudtza0DbP8dwEKVbybJ7zgRa9i8qReR4/2r8w+MiuyGiXcgrCSyZCepHgY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 4 Nov 2026 at 11:49, Christian Brauner <brauner@kernel.org> wrote:
>
> Part 5/7 of "proc: move procfs to what kernfs does", on top of part 2

Christian - way too many patches, re-sent much too often, cc'd to way
too many people.

Nobody is going to read these repeated resends, and all you are doing
is clogging up peoples mailboxes.

             Linus

