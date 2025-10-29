Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A94CCCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 00:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 500EF8E001D; Tue, 28 Oct 2025 20:10:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B05E8E0015; Tue, 28 Oct 2025 20:10:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39FB88E001D; Tue, 28 Oct 2025 20:10:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2172B8E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 20:10:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A66F259E26
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 00:10:44 +0000 (UTC)
X-FDA: 84049220808.10.4F853C2
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id C06A5160008
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 00:10:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=BPRMgUVL;
	spf=pass (imf08.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761696642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OAeYT3sIf5J+urxpWRZdGCYWbbcmjWbjfXki2vhXqBo=;
	b=djA7BVvXJjFka5h5SCVMjCYb5rVP5I++JLdo/9/lcU/eg/P4LiLw8T7YDkgw7zXEAcNoH9
	AfIhJ8HdNRTv4ZwQaA2UcMk6Z3/IXb5P4K57YXFKajDdpDp6eGLnF/MJ7zdfBkmdNJfEMu
	Ix3MzAw0dIzRxvbTword4uVeTgWu9KU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=BPRMgUVL;
	spf=pass (imf08.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761696642; a=rsa-sha256;
	cv=none;
	b=FsdvlxBZmaXLJjs0XoVMGKjzo3cd3NiMzjDQNv4cni11o52miaUgdYfYxp8dDT79KH6GAt
	revUtoN8oc2kPLnTY7zYo0Vb9dCb/JBJR17hl/5ypmmvv/HgxYaDxIfj5TvXlBufLmrFOu
	dY96zfyrbV1As71f9Ek5dmoylagS+NA=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-32ec291a325so5118050a91.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1761696642; x=1762301442; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OAeYT3sIf5J+urxpWRZdGCYWbbcmjWbjfXki2vhXqBo=;
        b=BPRMgUVLWVmE25iJQpIm2/oKStlcJENsznl4MxG11oOii5SKFPoMj4OxxAL0lkYXfO
         mFVpxP/uwIniE/Nbg8iCJgaorDa12Go5Xf9NwEUY2gvYNXaeau70nXblfIdQVnqt+nAh
         DDcv+cPjtZ27y6XXly9orXjt4VMeIiw6eoAGIOICn6O9AAzuqdYdTa3n0Wtu6286Iv31
         bGKH7UaXxga6updOkrh6qWDZ3edcgmXKsYm9CCTXlWtC3bwA9aTNVZYGpmgaG7ay/VaN
         dEsL91RgrTn05QdMUEHoDbHdQ0PFDVCdG6g+8XSWhyD05jGRCCUnr+5DJQHhQiifiRF3
         rnuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761696642; x=1762301442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OAeYT3sIf5J+urxpWRZdGCYWbbcmjWbjfXki2vhXqBo=;
        b=eryGQh22QfXldJOD1DTzHaOhVKYPIRx9+fdOiQPPEGqIriGPzUSRZlt2hss1KKiHag
         5u3ttSwLrTUUOUY6V44eQZNnPqT2epO+dkRxPbRzfMp6zxky6hk7hH9OhA9f9rqedGMW
         DQhOvnUXxvWwjPdR4ttvqmI3KX5JJGcJq0G+YQyTG1AGx1JfrTh0/32chbJe6OY9UmXK
         ZFaMc+N9ESF+q7OVoreZ/GXdTd2ji4hXtCW874phePg1i19FMnqPWUOPcj0gei8JOfbk
         4o13rhe+bTu0vt/U2Azojj9tdHdLMfrlylVvtf3rQ+W8/urtoe/REazN9ohbR2UOv5/2
         RM4A==
X-Forwarded-Encrypted: i=1; AJvYcCVLu9PK+w08fqRXykatU8Mu4wxzKnvXbSigc6xYppcD4EdT6duoAJqcmg4hyIjMvMRqDOrP1gQIlQ==@kvack.org
X-Gm-Message-State: AOJu0Yzzcnu0iIrKaeuBkyhthWStffPtUioB+NxO95hsULrclUjaGK2o
	XbSv1LZl5IoP2uAIcBynsgTxnudu20W9SSoABr/b+950oda7zJ0WSjikTZzOduRzSkqM9wKBJBG
	VcbtvAGiKiglHI9jlENt+GPb0OYSuXcHpxlXMv/Z7
X-Gm-Gg: ASbGncu3SZkL1cwA7+ec92DeVK1WvF03qkGsXo2Sw1+PvaBxGEenqJRacWdwbkmAUWZ
	5mV9w48Cyj2X3S8rstZdpnnroRefpFF5gBT8DpkhY4QeTD2GSymgQAHhzzLgRUj2zQED51tC5US
	da40ROyVPntKvEQh8pJeowOw6RGRmuL0oJxhu5W/2tZmfJXmzAFVU2hN3q4QuiiHiZ/71edFmPJ
	shlf6DGETBKI9ViqHE7Ljk1ZIBnClTt5RGwBuwfStiUMc/X8CKnfLHtHd+X
X-Google-Smtp-Source: AGHT+IGhjs8q4GiygXwr6DCqhQXMqWhNs5oaPfnq5KAn4id0agHe+xmdqRLWlZPNOFZ/N+dUgAnaM8QQHq+RXzkh3rE=
X-Received: by 2002:a17:90b:4c8c:b0:32e:d600:4fdb with SMTP id
 98e67ed59e1d1-3403a2a1014mr987268a91.18.1761696641654; Tue, 28 Oct 2025
 17:10:41 -0700 (PDT)
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk> <20251028004614.393374-49-viro@zeniv.linux.org.uk>
In-Reply-To: <20251028004614.393374-49-viro@zeniv.linux.org.uk>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 28 Oct 2025 20:10:29 -0400
X-Gm-Features: AWmQ_bnyVa46lrJnSEC4p7b8a6-fhgKBPo6xvMl8XVNnPJL6uMjYjs2dxSO45Ps
Message-ID: <CAHC9VhRX6kqFbbKuOoKOLLve6c+7TN3=fXHrtXyj=osfNYd+2A@mail.gmail.com>
Subject: Re: [PATCH v2 48/50] convert securityfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu, 
	neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org, 
	rostedt@goodmis.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, 
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7rgd6szu3wygc4q5k75d5zrt1rdxgm5r
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C06A5160008
X-HE-Tag: 1761696642-30247
X-HE-Meta: U2FsdGVkX18ZhDbcDiO2HfYNL6tOcUd4cLf7NnS3+X0wN+xxooTQDtv8tIApIwadsXulgtlY6sMfEtRkBon0lgVEbAEWwBl+VYuwwaSL5HMOXaFJXo+3pMCgkEM7zZjkkj8fS5HRCbRSfZQ6noAk7sOXxy0JHzyRzFN87ubX9vYOqqPiGRSPhoznPUfGUrGQjKY6yf5TNU0feVJaXpvsrKyGhW08ObPMLPTANbyCgjCYtJ4IixiyMI+Lti9BVbEF46iQRXb1LTjeiAZYQ6FHu7SGiNHdL6vTk11n6jXcBcpKnaA0Zn+DCJFo20ly4HTF4MCvNAMoBOlP1lovGNAiQUqpYjoCZwoYrYQjnwNjsfsA2iBomrfGGPlb1w2UPXUCQW6IYVEy7LLPBy8xERpdqmGQU9idRX7ZULwjp+JY2fkHB00bs3Gs0/qMGZq011L6WYdNwlidaNmMAzWwhztvhmtwt5PyAq0rBqQFLUAY2LOUw2sICs5LG430j181GC7dxW6bZ9L8/+ZU+ZdzrG+LuLUllmezW2V2WEbRK2OzJyzbHMrFt8vif83UpPpDnXD2Bnep07+1mgO+kTKdPDGD7eaImLyvibTXrYRQ1xoclgt8LAwH5lX3vmYh8/P89zZwV+LNNVvi2I5Ama7PHtxzUITIGg4iys89Pl15pwEzmrgQIRPr3q8ai01bivZKleqb5SSt1VQ1803iaN5SegVpGLn+F4Q1ZZU3VUR9jyHXJZNDQig1lbTJLSOa4xpLmYK/wnYQUCYLi2IqB4cqmk3hG7D2XYq/wJv1h9vKF0DsGQL5d8XK2OZ4L3x8LnqHMtrLcdntAb6HSr1PsFKIQDRWWnOgpGqsOS0TYeq4xqkrvex0pklpcmKuAu7DUu7ZD5VsGk99VKR+hHKkQEE4Iy1n28tk+IYh72WYTQSVEXOCs8fji6K6Kcwi1GgRxV09V8KzZ5ctVVYvVlUi6yQeaef
 ZSdo3LRe
 ro2DPH3bYgENyY827tG5mq/PMKWf5DPDXWa3Xy+T3Qj8lKB3HmUYmLxKUjH4psTs5XJ5moNtzKBS3GN4RhIIEQ3TITarpURo2ZudqLhnY+TfGTY0fTofK8COEiqrhC1AwZtljHeVlf3jWR3w4PMC5t95GGztWqEzF66zvmmKx7+7m3GKVKtEU9EoICgtcqjZq9iy20BcUF9Wb5mBtSWcfpuvEu2xrg94WKVnFaa1PDKwD5+gbLljjczG/zbz1RtQHruDPjak+r0wcCU7ss7YgdvlLgGOcyx5ptoi0AfdxlAjNQw04L+MlhCMQhiuE2C4vAf27pNtiZH2z1yvEOFmDfa8Z916HPxcHTegg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000364, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 8:46=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> securityfs uses simple_recursive_removal(), but does not bother to mark
> dentries persistent.  This is the only place where it still happens; get
> rid of that irregularity.
>
> * use simple_{start,done}_creating() and d_make_persitent(); kill_litter_=
super()
> use was already gone, since we empty the filesystem instance before it ge=
ts
> shut down.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  security/inode.c | 33 ++++++++++++---------------------
>  1 file changed, 12 insertions(+), 21 deletions(-)

Much cleaner now.

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com

