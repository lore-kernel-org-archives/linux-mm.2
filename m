Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB0F606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 00:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rVpvjBMN
Received: by kanga.kvack.org (Postfix)
	id 6205C6B05B0; Fri, 27 Nov 2026 19:55:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D15A6B05B1; Fri, 27 Nov 2026 19:55:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BFCA6B05B2; Fri, 27 Nov 2026 19:55:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4FF46B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:55:55 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A6D11A0527
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 00:55:55 +0000 (UTC)
X-FDA: 85482710670.13.6CC72AD
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 93D5E1C0004
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 00:55:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=rVpvjBMN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795827353;
	b=u199uSPT0c78rUREdQltG87FUdi52YlfRqCxuFWMAlIzaEzKV6NS/n+tcinKUh53TQL8dg
	vmzDEm8ZF5EtPiZQrZsvPpzYJJyBYpDdjE08v4MJvugBTAtAGf82ZNcip6x22mMPSr2YFN
	7C/0VMa5f3mmZkhPuIL4SFxi++1zr+8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795827353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4YJXz2C1qqMpFfvawPlwYq2ZIDKs+0ke0HB93yAMqs=;
	b=UiRFxiBIBh4gEUKyoUMojFCymCN3EKDZ/M/sQOmuPGcV9f3AkOsOeVXFVlfTWjjwz/bxV5
	2mZ33+dGoxz5crfF/jvopxaH8s8apl8AJfSk1SnD+DeizLvrXC5426KGESzs+6cZxZu+dJ
	3zZlIXfZT3gkclfYzxcVDs61WCbdhJU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=rVpvjBMN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4bb9d8e8e90so58026695e9.3
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 16:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795827352; x=1796432152; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M4YJXz2C1qqMpFfvawPlwYq2ZIDKs+0ke0HB93yAMqs=;
        b=rVpvjBMNbF7R6ahwGX/y5WkJgch+WYUzU0pQ9Pnhay2F0Dud5sajimJQTM6UjNWv6T
         MTdhzqMfErQphYXUPEXwQQ3vbcWmgtxsSV5rDJ7Ry6nqIjFUb8gIehiTeWpuMcepz4pH
         /usLWdFDRfvTRk6lpgAOGHNL+/ADq6k5GNu9yWIZJ9aJ72bLA/FCjL4RxSAK0q/Ne7+0
         0G643kKP1AdQYKSh/ALOp+pyK67jVPz5Sbsvm5kiNAGxV98qpszr8aKX06CNb4DHVLWA
         Nm/2bkxzSEdGoQpdPbPA3YWOCwsiOxl4tdFm8ZUaVsLssatno/Pe5B4PjwUESIHf0Mfb
         dHEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795827352; x=1796432152;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M4YJXz2C1qqMpFfvawPlwYq2ZIDKs+0ke0HB93yAMqs=;
        b=FW5WDsbru0FK+PhluEHwSFMbYtdV1neh1yDpr9DPUbETmSR3HAqvMX7Xc8fzDd5wje
         6GCMR2PVkkjNU+vQEfexsbXYMQDvuEoT99llQno/bryN6nprEcZPc3cUm1Mdvy7GvbB7
         6u1v3cdMVUbBvdbrujBu1V7yFADIpWWPobDLnRtSI0fA1MyEgj/cSEpG1aCyOtD+3/fy
         Uxl/hOq6OYHH1aNZgwlegVY66pA+CmENycgdrvj30Ez62ZKXzu5A8SvIYR8cDgyQ6KAC
         5HHn5mXLBUmHwZcpX2puFogZNkR9ePLK74natnM8dQ6rew4WU36zpYztKeFApZjpWM8R
         qPYw==
X-Forwarded-Encrypted: i=1; AL+hErExhpFlyITfhecZYwqr0E4rZuYWuCV8Ur7jlTg8HjLdQb81SOi8YQbTPSGkPp9TQ7fsnyhEBczzZg==@kvack.org
X-Gm-Message-State: APuU4Z8Vte0urkHW5pOK5HrUJodPUf9a4rYYHSKGoT6zbZqjtqtN7B1o
	zrmlRlxKZPMFCQysBmFzNDa1k49I/V1pLT1qPSdmKYPYHOAaWU3mNT1x
X-Gm-Gg: AZFdTZc08GBdvlIbuJk/YmC5IsyR0kO05kb7jSbaGouqcmrSGDvQvKWWpRY+/yb7aHo
	zgNGDAp8rJxeJDJqpjYMZ1mKSYUsG5DZDkZgMbgvX9SWqsi9UgEY7hOOGJmq5grdSU/H5SoizzT
	IjvOBA8qVnZ1g4MLoiBmB1UDWNQgWcXrY197tHwHezefLdQMx9Pa5emHGh/5ftTks4MTh5DwANp
	h8guEwTYoFSAdubiAAbr97Wok48OObQGE9JM+GjgUCC9Z9slHy+KeyBqzY2hN6mO6J7LA+Xs50n
	gtddBEx/xFGJmfP0Rag5nIahAlLwtuZZWGybSHpGTPM9x3IKtndchf0S8HyS/Uu2OCG1IRCna1j
	NQdfGJnPwgn/qT+1TJwnbFLggifahJ/DfIgK1H2L6s6lUl/suDFyYOUgrmmohIeFXRSUqyIrfXQ
	K3e3m5/38uUNCJHBCxT7OE/2hL34Yek2rT6oBvGvOI46mDjX7nF533FI8apjgrgzPJhne5c0oew
	q85Xk52F7zI5pjrLe3ihTWX7TXnep6vLjCcu41Z4ZaYbIadx4fJ7gTG5j6le+lItcNtRSuOznfu
	dzt1TWC3QS0aGErvu9YQfKIniA==
X-Received: by 2002:a05:600c:4e0b:b0:49f:e772:6ddf with SMTP id 5b1f17b1804b1-4bb8881ae90mr541218935e9.32.1795827351797;
        Fri, 27 Nov 2026 16:55:51 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4bb8538b09bsm1328407645e9.4.2026.11.27.16.55.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 16:55:51 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: jarkko@kernel.org
Cc: aleksa@amutable.com,
	alex@amutable.com,
	arnd@arndb.de,
	bpf@vger.kernel.org,
	brauner@kernel.org,
	containers@lists.linux.dev,
	corbet@lwn.net,
	dhowells@redhat.com,
	ebiggers@kernel.org,
	giuseppe@scrivano.org,
	hughd@google.com,
	jack@suse.cz,
	jlayton@kernel.org,
	josef@toxicpanda.com,
	kees@kernel.org,
	kpsingh@kernel.org,
	lennart@poettering.net,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	luto@amacapital.net,
	neal@gompa.dev,
	oleg@redhat.com,
	paul@paul-moore.com,
	ptikhomirov@virtuozzo.com,
	sergeh@kernel.org,
	skhan@linuxfoundation.org,
	viro@zeniv.linux.org.uk,
	zygmunt.krynicki@canonical.com
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Date: Sat, 28 Nov 2026 03:55:41 +0300
Message-ID: <20261128005541.873229-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cz83yus49t4amregu4s3z8zb8gez66hd
X-Rspamd-Queue-Id: 93D5E1C0004
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795827353-663528
X-HE-Meta: U2FsdGVkX1/AM1JdzCz6lWet6jRn0OW84DEyJjDPmxc6ST38qJDylT7RGgp2tyQz7/7cvB9833V51tzHj9Ja+l/QGmFbKbl5PEFtpg8xHMLIEf1LQlgt1zqADcHdfYIGCQAeoXicNYBvXOPEV6zazQKOe7XdlQCXgJuMD6jzQFgF1hTKH3yUvps0sJUsn3jCXB9Z62Vu4pYfv3ZoX+yIG+3Pfn9IpS+z9jzi8KsmT0l7LZtWR+Bo1QIldPjDBObvVSlGHjg0ELvKmJpvpnrYMDf/14J8tkxNv8krKolMPW992G8S80GOnG2vKxDwSSJbgWTRBli3b5aVwu8wuccpiEg8qE74E5sBURKIt8B/xudLeeibD+1c1g2uWiDbsdJSFRDXuCmIUs/xOh/IYHacBeglyakQ9hpWJWHHQDnJeEiqbzWxnEAClrLpsMTOOMaKBXHohxErgV6t5u4xT9eo5z3d7vWN0HS7YAFxAGgH+N9DutdZSYmWOXEJon9LbQJbaJajkQ7xJG4JJRU6zlmw0puQh+kHm1bFI00B1KDJCNzbYxs9F5hpyTWynt6XMkFfQzBHfzIqLjcPNhOdZlkCpx+ptCxF6muLXRkJsf2mGCUCVlzd0zhziielU992iYzDwbqQP35gl19xWnS0ryd/VVXybV7+N0RFZRiaioLAn5Cpv6lJCmJa3r1cc6syqIrf6v8EHbt964zZmv6RR0s1okr3/ZAA3OV8QriQcVEQKg9qQ4D/kYGfm1zcwQXw70kBAO+Ao+TJY7AyXkQgf3bJzLeBOgRJ0zzl5gCP4gM4hStF7gCkQn5371kxl0UfkhrkIM7KjXZfAqJA0Q1ZCXO4yM8ZeRXRXcMaRD6HGhgxQ2JPwLQE/Z51pL0qIDqvAF4g+ewQrMZ3pMr9T8X4fxpgbx7vllPLOULYcrW/MKH8jCx/rY22qnlBb06u7gTG/6Ep9+yFdof4YEQJ3TpcSDO
 6Is5JStZ
 69JhxeSDxM3qxxFwKwZXR60mb2l21HefXjPjibN4SlaKq2AXygahJbf9IWqECtm+II1SQ6OZyieQfsestHQ15Zur+202SRO17a6KueK7qWfY+/LqyVtXgQxXcVstKxC/JWq8HJ16FQ9TptJOqbJdX5xjv5XFxYP9Dr7L04rTofhgODC3EAW485aHNq0yHyOr83QABk/2Ea3N75fxemO19gXDhigtcjR1Cbg8sHzFjEmcYD/bVPFBP9MdatpQGF6RZQGQBnh9vz/zuX+Vu4V27hho/aQbymwN4v8JSrsB86NmitHJ1Oc8s1zzlkVuhEK0aAH5MtI/egc6p5tzgwTUN3CQuyrscYID4T+tP8HaDIEOIH4o/19QMCyV8fiWtCRqIonZOB33THJWYnkayjwKVxKWZ+Wbb471Z641KWJI/piEMl7mN6WiA9G9+FdfYcoSe6ynI5wnU4+fNfFBQ7RXdIu8ABBN/PCmeQw44ZzFRdEmR/Mk+BRgo6d09atQqBtU/A9QAuJW5BuOuGIlJqhxngQwttVu8hlOYT295J7LRZpmc6188FhYyqPoSLTuRZreXWwCq8LE1Rg6XZXGG9NJCgJeJDrutawi2mKwRjkTPPtAfGyNRAn866FZuw/mZcBaxrIF7JkqwGOmqRI/pM6cUk+KM3zdWPgFEogLWfGgHVev1aXIDixTEi8UPB47ft0nJJ3WZC5B+4OaknYcjg8MePbE3qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Jarkko Sakkinen <jarkko@kernel.org>:
> Work on this feature started in 2025 after reviewing David Howells'
> container object patch set [1], whose underlying mechanics made sense to

> [1] https://lore.kernel.org/all/155059610368.17079.2220554006494174417.stgit@warthog.procyon.org.uk/
> [2] https://lwn.net/Articles/1102593/

You put wrong link in "[1]". This is not Howells' container patchset. This
is Howells' fsopen/fsmount patchset.

Link "[2]" seems to be wrong, too. It is not something "earlier", this is
very recent LWN article.

> While the patch set is manually written, the original motivation came
> from isolating LLM agents

LLM agents are too strong for Linux containers. They should be isolated
using VMs or using some Linux reimplementation, such as gVisor.

Bacik said that he tested his patchset in Anthropic. But I think it
was tested not for agents themselves, but for something else.

Anyway, I suggest to drop this phrase from your cover letter and think
about some other use case.

-- 
Askar Safin

