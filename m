Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB242606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 00:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dD5jYhIR
Received: by kanga.kvack.org (Postfix)
	id AACB86B00EF; Sun, 22 Nov 2026 19:21:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A36916B05B0; Sun, 22 Nov 2026 19:21:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FEA86B05B3; Sun, 22 Nov 2026 19:21:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 580C66B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:21:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B407C120757
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:21:21 +0000 (UTC)
X-FDA: 85464479562.28.E93070A
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id D8917100002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:21:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dD5jYhIR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795393280;
	b=B23FhQJrYfrj2IpiFbMTnE9Fjknovg7/FQpuWpVphOHF7ON7lAEo8Vk674ZdWYTLX8YQ+e
	weie3FBTXalj2bj12pxhx56c4VCTaNvSxxnrE5nJzdOfn0MW4ZiXxWl0X3cogzBWia8SRp
	hjEMGD2r3xd/5Hq1EWiu5oONNOandiM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795393280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KF23iyWwR5yZnzbUCvNMaMixSGrIyVPB1oghCsOfI4k=;
	b=DZGWrpwqNRxhX6FiQaZZ1bfTBHze8efS4kAzo2LYM6M5mPX1lYKwxh+QjlE4JG7f0kGS3z
	OTsRi6c6W3DUSwKOmBgzlG992dRNak6U62CP3uPOCefZBkmu2Yk9zrEr8F0SkcTZSyny9k
	7cSDSdJGuo+aLMBtXSlHOyBCZT+ADfM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dD5jYhIR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cdb2e0062bbso970064a12.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795393278; x=1795998078; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KF23iyWwR5yZnzbUCvNMaMixSGrIyVPB1oghCsOfI4k=;
        b=dD5jYhIR/zI8OAg85FxBKAxv1vIpKKIqYepzTnen9Okp6WyQhJb5fgoU+6PkiSlaFv
         mzHsWH3cHgtYet0dh/1rL2WSJDum9aNSiubgtLezvgbQbTa+ZKdUGoR8C9GjPQuZ55zZ
         v2iPoT+idMlnab47joEQyl2jasuSAec/cwFDi4KuVWqRIcQ129TyB+K+ji3BtQ9SKzqW
         3bAiqqEaxPb0PkfSGZ4lFPU4UM1nRdNg6WKBBxXsBSpZC2/Ltzvoq5QAbggJ933/Qx9e
         wbAggduQtxbGkw7Rp2Sv0K8cEblUHzdvYeXUdwlyzMWYVs+4xk0MNzV/EnuFtBWIri6x
         eoiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795393278; x=1795998078;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KF23iyWwR5yZnzbUCvNMaMixSGrIyVPB1oghCsOfI4k=;
        b=GuLDlHTaZLaLTBg7Ilsydq4z4WPbn77xLw4XR4JoXWeoSqWNrbSgSuOwuzzm1iJ+ME
         SJwT+6OXj7vUrQkB1xzGUZSC2MkwHocdB2tN9Pp0zhe7MbSgaYX0431jphnFQ0N7KaHb
         30C29MvZjDMIggpxZVbINDircT8Hsc48yBBol8HsMVDkjauGUxkn4UR90gVJVBbU8LS0
         z4NDCA0/rOCeqLlMqeuYjmwLMRsVZlw7F7RFYJKmoWDrCRZaAB9cZpWWZuXVbR4pbkdu
         gIjyk2yBI9Eng1Pc6n87TCBKhyYh1R5gkMMuyei66FufIdzebKv1nTcI/sMI7kIE+ckr
         WVrg==
X-Forwarded-Encrypted: i=1; AL+hErEH+Ocb4vT50KQWbFyoqVEq1TNpk9e2rqtcObmzU+1zwYTHPGEMAj+rVp/xd6v4aLDgNmBn1WTOsQ==@kvack.org
X-Gm-Message-State: APuU4Z8oQhyDOuzKbkZ2eOmSAmWoBDIvgY3pJwjfF5mdNIhx2Vv61AoL
	wfX6lMDc4oDHdlgamDr1EEkUlzfZG+LWT4Z44+8jFtB86h9uk9mr9+li
X-Gm-Gg: AZFdTZd8MfxDWayY6lGWA7LmElitUW1hoPL6rnM6xQffzgOJjefFJoBrgexTblroiuy
	MLYeMOUDFfxnxh73CaKVr6Eoi3g5xWQgV0LL3JbpJr0gcChFt1FBbwOP4EhvDI3NyUwpJaJf5Je
	qDdAdQC7hoSbVL4b6nI8iMd6LNsO2PHqeuBsikcNvvPZRvNSSO2IBTytduZuEMszcQ/zhUFANvz
	w+cDMOuk50L9+GH/kAeAnTws+KAtmqaSUS8D9zuQIRSyVtcA+uTdhTHeJRCsxvRGl2si8wqhTEq
	NG1zThDxtJu1LzcMfXEPiTJ1PxbFRyvvYSlmWlnQIeV/oxFPC2VfVyGE1HrKBVQeUhnrBlERGOs
	1GwdpMr1+elmPetq2EAOVUeaR4ST5ffcl50SatNVKcR6kaz8zCpd51Ywned7NrHXgvR4th5izod
	Olx05kr4IqpuIyKUOSjnph1xjg1ailPo8Id+FvGrjN4BXl1FPs8i8qKgZWnyjoks/KYf+ojkQEX
	En3+/+eSDMl15p1CVrZt6jiH2R747JRSBFgdaMEyXJYiFsHdL5eXLv7es48o0IxfepOmhNd4uz3
	m64hAmzumcQphKHvwGUJfn4HNoRcuy13hVqP50qDkj78CjarIMwc3I6xOU+o4RGOH57UW9dm5od
	5ZrItpY3B267fiHkVN7AaC1duB0uPmYnemnk=
X-Received: by 2002:a17:90b:1801:b0:3b0:9984:18c9 with SMTP id 98e67ed59e1d1-3b41c8e16efmr9088622a91.11.1795393278264;
        Sun, 22 Nov 2026 16:21:18 -0800 (PST)
Received: from localhost ([153.61.198.247])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b44b8733e6sm4860403a91.3.2026.11.22.16.21.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 16:21:17 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Nov 2026 00:21:16 +0000
Message-Id: <DN25ST0D5K1J.1NI5236BF2BPY@gmail.com>
Cc: <bpf@vger.kernel.org>, <containers@lists.linux.dev>,
 <linux-api@vger.kernel.org>, <linux-arch@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-kselftest@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-security-module@vger.kernel.org>, "Aleksa Sarai"
 <aleksa@amutable.com>, "Alexander Mikhalitsyn" <alex@amutable.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Andy Lutomirski"
 <luto@amacapital.net>, "Arnd Bergmann" <arnd@arndb.de>, "Christian Brauner"
 <brauner@kernel.org>, "David Howells" <dhowells@redhat.com>, "Eric Biggers"
 <ebiggers@kernel.org>, "Giuseppe Scrivano" <giuseppe@scrivano.org>, "Hugh
 Dickins" <hughd@google.com>, "Jan Kara" <jack@suse.cz>, "Jeff Layton"
 <jlayton@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Josef Bacik"
 <josef@toxicpanda.com>, "Kees Cook" <kees@kernel.org>, "KP Singh"
 <kpsingh@kernel.org>, "Lennart Poettering" <lennart@poettering.net>, "Neal
 Gompa" <neal@gompa.dev>, "Oleg Nesterov" <oleg@redhat.com>, "Paul Moore"
 <paul@paul-moore.com>, "Pavel Tikhomirov" <ptikhomirov@virtuozzo.com>,
 "Serge Hallyn" <sergeh@kernel.org>, "Shuah Khan"
 <skhan@linuxfoundation.org>, "Zygmunt Krynicki"
 <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Jarkko Sakkinen" <jarkko@kernel.org>, <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D8917100002
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: scbze65zft3axfsqeire3y4kff6ru9qe
X-HE-Tag: 1795393279-308291
X-HE-Meta: U2FsdGVkX186tV0YW4gSlVpDmdIujW3Gd+5LIntYEE9rmn6xXDYK4chSExGp+bbzwoV0jUlazvO1lN4noy+3xPE06Rkd7yeNaihZGCvc1is+VbNHBgIO3FKn2WtNfmMel6SthowkyyhlHw7MyHaqyD8N75srKFZsGBOFCMaW6h3sh6O0ihh/iORQSGHtCL8S0tCXUFHoCJuJLMXMVrcWGIU6Mj8ZtDLOKY5KAmyD0IneDCaeA7GBmEv7B1jKFr2jp/TR7J7yZpYm7YEk4ctVodhIXD0E4duDcS8iK5eqhH1P1J5VMvO+5xcUnYWIVlCJWMm+TwygmfWAeA2hEzeYWaFZyQltpRYMQYLRyVWq57C56r8bFwwf+nxq+OUjxQrrJw7J7hWl+ejv1ug/WRNrc4iNRTkLWKskUr0JswJD93xC2ZXouyl67VUngQ0rPM5g4JqDhcNANTV8uxG6mWySdeHJ/i+yvoq/cXgNZFvV2t+o6slkdp7QB/rIeXXMW0k3bOhpawqZzhVZeMGpK6jFcFcJgBGZnt2dpToHlwjEbsZVeJaAAInapey9SdOwzpGe8qMVsJq3XKngEEr6SaOxxdjHX/+znx2ghjDOlgznqClbQwgtIn1J32sXRXhOQqY+4+9y3pTpkBO7CN7zwwc+CwIwZvUEN2Gsee25YU7vb8p7sGm7mZseg+IhiUQkHqmADyRHesXY9VwnLJ/XkCvzaUMGDAaKQxiqkjavQ9JDIGlhUU0UY6xndSiKRejNoki/R1yePW4cKcF3fk1gq/V1Rshgnn5w7brohf6odM9Ll4owqjxwshrihxtguBT0/30018QNqWZ6CFg/Q2tx+SFquKPSI/oMzVYQdSRMfnlRx5h0r3Q3zkJNNqhVSuuzxp+CHk/EdbX3ci1lknj1kED3AopTHdvepUmtH8p1EmYXZmNKFJA8dkrMY2fPzw+7IIdiBzbBl2HY9Eiyq5iDKbe
 a7277zAV
 tFgiFoWN1lug6R8a1eEKCFKQlG0AJhdH33m5bgWfZQinYVdDJzjkb6uWxd/FejrCKithh6uXRm1UE3rlfRlB6FQLGGRzLZxZP0uh0qhLZGqeFiSxaafqqzdmi8GbVmUCobWU6Lv+MdJLqqKvy9iKpPq8pVTDC8cOcuBfUvtblISuQa0ACgPI7vWXqdl/8rq2Q0v5PV9rmmdexwtgc0Lw7ShtpKwBWgwDRrpPd5F2O/GNBL4+7BM0D9ZNyCF9j2zW181SGLI4ZF3m7wkohF/fY+rmIll1mijGC+ikpQfkAaZN/cVjavP51ASDR05agjNVpHeYK0/vwRecZXn6Nq+h9I8AUBoXy1N4QfGwTXKLf9UqX09CHRUUgR3NYvpvxKKq6Q/8DlQFaMGE/09xNOi12evnboEph1632VYTX+phYcce5BUkmt3QFCL5erWhEoWkBwnPb94Hi+r9KSFECiIvpYdrdDtdaZ0mwYjttFuZJ6fYq1C908aejBw49Ff4RtLTipzMlYkMOq0KRsHdqRZORXftJtd5OYsKBX8vNwF9ARrYQk7uSXqsLribgsaODOTnFje3aNqR3eNUHvExUvFUhh3I1YpIU+pWpOh3s9wFlVADOXwt+gDNt90hHjNsc401hHn+tFg9lFsZv1dNXLlQs/FbS1FKbdHJsv4aYC8i1Xd3HbIq683mqm6USaVujXofBvq2rdpGpA2Piienqib+JF2dV9puUzcy6Y8r4eXgdOdCofey8eMtImwPyoBEi8unJ58HH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 11:35 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> v6: https://lore.kernel.org/linux-fsdevel/20261122011809.2667684-1-jarkko@kernel.org/

v7 was sent 18 hours after v6. v6 got replies from the bots only.
v1 was +2559 lines. v7 is +5782.
All six findings of sashiko on v6 are still in v7.
None of the seven versions got a reply from the vfs or LSM maintainers.

The way you're spamming people you're only reducing chances of anything going in.


