Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F1DCA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 10:43:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64AE18E002F; Mon, 18 Aug 2025 06:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 622A78E0007; Mon, 18 Aug 2025 06:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55FC88E002F; Mon, 18 Aug 2025 06:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4676A8E0007
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:43:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9AD0C08A3
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:43:43 +0000 (UTC)
X-FDA: 83789542326.21.9CEE8BE
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id B563A1C0003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:43:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NUJhTPmK;
	spf=pass (imf21.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755513821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6r3SaHRyW0coFrYXSGevRrDyhzWvwUgHlOXlsOiQukM=;
	b=day1texuCvMG3DyoveahduzZIVzInaIc+EBm+NJ7c6Zmwo/sL6c/zA+MrU7rrjm81tiavv
	W7OZ0iUUWrJ6mnIjhUsGMPEvYDDYbRXr0WLh8u6eqXb1cAo7iT/EYR/z77sDwvyqblzilG
	jtGnBunFiz6iQ8wzynS634GkKYx3Zec=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NUJhTPmK;
	spf=pass (imf21.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755513821; a=rsa-sha256;
	cv=none;
	b=krG35CxZcCyXveJ/kjI4lSmOILQU78InKDe0Rzqb5NEL+YvAHKw7yrEjquLoKoabH93iGz
	BLKyhbpl2naSaYykJv49tfymj6QOv3Ov837cB8jHzzGs4IiiwZSZKqsIHXdnsJRgdLanJ+
	W1Dxnf3luCBM+Hm1+bRfeY1LtMN1VzY=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3bb2fb3a436so2131453f8f.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 03:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755513820; x=1756118620; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6r3SaHRyW0coFrYXSGevRrDyhzWvwUgHlOXlsOiQukM=;
        b=NUJhTPmKvfdp5AH5GD6N7E1zi2BYoNjbonALm90C6Cg0VCzuk/gqxxeIsNwdNwUiW2
         GbVt8cPBWG6SgOCrOTf45vQpOAlv359bgw35MSZCC8D8W2iAeZMKw+7NTk3l4SeSxtWG
         O7ksO5lQOuZD2Erfu5NzzTlSG6gbkO+zPAQtPluNRtag/wy2T2F76e4j7KILr7IfZg0Q
         GVo7AJTfS4yFXNxb7ly4bvsXYlfiRxKqabA/DNY7TKlesdtBIs9aBq5n7FG+E6gKmLZf
         gPbJaH4hi0sdceBBde5E8179tQkgQbO5KOcwbgb+lMtbjq10Dnq7JIkClMq1kTRM9nSU
         0DTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755513820; x=1756118620;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6r3SaHRyW0coFrYXSGevRrDyhzWvwUgHlOXlsOiQukM=;
        b=BAq3ArIxtsdSUtOWA6/zqASqzGadgI6hJXAFgRhcneRaQaUCYOel+xeIoVuocxHVd/
         DCaskSYSSbqJKqUQvYDyi6RWRPXyGk+VA8xvgWnslblvDZr3ggW2eA7uIQa/meoEaSQ1
         hZRPXLULSFmP2Yue/C/U/f7GEtcDlJ5OOsvgi8pcKxidzj6TGM5Qsg632khEmoboFFBJ
         hjQF5xGWBVl7hYVOoa+fMTasu8S1IVCHAo/YRuorEZqAtsQBmpjeUfJNRpCcKpGS1WE9
         EYbcBfPXEe0mmdV0dGvUw05jkGXm4N7O16FzXgRK5O0ws3Scl0O0OxWjYW78Na7iHx4L
         lQXw==
X-Forwarded-Encrypted: i=1; AJvYcCXRJfS1edlmnRPiFjSCMa/YM+f6xY4qITm32nehL5A0t0Ck4EvaAHMmSBefZv1uvT6h0gR3GZiXwA==@kvack.org
X-Gm-Message-State: AOJu0Yy2pJyMc6lXp+mMxBfJaSfBth1N96XutV0YXq8hBmTT3mjtNGEW
	xiXUn1d2mT0HiArZYxetHwO1VLOsGNq3NqyhGP5A8jGttCphlgO9a9If
X-Gm-Gg: ASbGncunlkpOIMsnFHve2dAa0k0YCiWLKPJ3SWMEJLBoKTDbEzVFRW3tUjqP9/LpyP4
	QCqsELZg6KCedIwihVXPBYU+sEE9WV6bSkdQe78jbXQCVSvys5JJFAyuRc+yx5oHZSEPtExfBnk
	3k1Dl1GwOVMKGP6XL1A8EMA9KItsJxjYoBCevtCloNqdJLynC1mHdytPk/9Q/x6wJHz4FiZqYTw
	aHys4UlCoIfiugZwLPDftlJbW70O+ZrU2COUpz8fAhSNuMnlBYuKMWf0u8iYAB5rNphSxI9FY7T
	QkoDQdSy4/TAXa3/s7xi7dysjiczR2cZKke8CsATxCMd5w9oWgXmHsNy1xzzZsR5mZ4CkT5IjvG
	BdFVEWbZMfKNjAxoYE7yv4Kam1exYDjNQsihPq5ym1vhPbYHo0H/WLc4Hud4BGImYY67rWWgYOj
	t5bNCnyA==
X-Google-Smtp-Source: AGHT+IFsKR1Ldy5RQ1PDhrHI0xRfPnmBR+5bPKLtaVpXzp3YgdHRXH22mh0OTnGitE+mCt+Wq/AYAg==
X-Received: by 2002:a05:6000:2501:b0:3b7:8af8:b91d with SMTP id ffacd0b85a97d-3bc69cc2bd2mr6578410f8f.35.1755513820124;
        Mon, 18 Aug 2025 03:43:40 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::5:7223])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a23327809sm70936965e9.5.2025.08.18.03.43.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 03:43:39 -0700 (PDT)
Message-ID: <5560e517-aa26-4693-baf7-e618bec3c5fa@gmail.com>
Date: Mon, 18 Aug 2025 11:43:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] selftests: prctl: introduce tests for disabling
 THPs completely
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250815135549.130506-1-usamaarif642@gmail.com>
 <20250815135549.130506-7-usamaarif642@gmail.com>
 <a385e09f-f582-4ede-9e60-1d85cee02a3c@redhat.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <a385e09f-f582-4ede-9e60-1d85cee02a3c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9dogr31by4jkrrcyfgimbcd3kcpbnzec
X-Rspam-User: 
X-Rspamd-Queue-Id: B563A1C0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1755513821-337902
X-HE-Meta: U2FsdGVkX1+SGAgzMImACHLjteQRF4bZtwt7w6D04a7muKXC5UiYKOifnMVzmw9ZyCtZiMjo24jjuZrYK3oc+3fJIafkhXaYIpkYirs5DttJU7fD9uFRH51S/4B+Tye/OIoasBSg0gWPDIJtlSaD/JoGJVxTjtQ17oAMfBv6fq25aUEsJRl1ZBt92l50HTPvDbgxWBxxztdiPwry5pDeQp6jbUggi8Rw0IViUEY0bp+KpYz4I6b3JwC9MBW4uSX4xPulwbYRIl6BG5snheWrwzIlBNmF1SniQ38IOXqu4jwrSOvOXGGNlmqjJIF/CSF52LkmLWJiF/r0TfLaeDL1wUPLyInoNw4ckeKXGTeLDyB6CMnipC+jC2SlkM3WH5n3NEat0Oy+pZYrY310Oeso4KqDKmGoXOlt2zNMb47VQuqjNFph/j8oPXMWZIRzL4Js1+a4ZL68HfdE0JHC6N/LGkB4tU4z1zM6G3KRm3d73V4i+lLt6sqpfE8F6u4z9wrovOB6Y/33MD5tLj49b/lg5RX44uIhZwUiZ9+bfAzNOS8Uq+U/trfVmWuqkVhWbL6rG0x+WfzjAYpgnL6jA7cJNPMLYwcgtsYnA+CGZ8qdwzXX3yh0qdvQZv3A4zbVxtJGPawivU2lMV49DHmbklMlfpn8XL+NNxIKA1j+APJZjVZTZchqpgRQ5cNZ9hgoWXE/Znir0Wm62xI7d/hG7lP37WS0CFe0ZXn9XHbMTTSFXSGItlmuMoj9lSJoK1dUUH///d67SfPOpCODO8PXSDdk+tESPrwSIWfoYBTiMzbTCeC2XU66v5sm5DB/5wozOjL8f3a+dZVcLTb/E4ES591e8UxgMRyiaYUBqxRvyYik+0tYuH64lfIqwwuTZ6fLziATFF/zcX0svge5YDZucbwZwzO7+VcDat/Rk2i4DXUtp/AWJZUOW4OU3X/Nf8QZ0s8Am9AxTg2A0Y/SbeRYNes
 05QYOA+N
 s+Xwvqbvzj9hnRgFz3erx52G/ILr/LJC/J8YRwusG/JMpBfiHPtEfY7EeJUaNWLJaexYIttRZElkWDXHEg8UyJnzCzA0hjC3dVETqj0Xquzu92v8onceXRLQ0dmDpbv0mlK/Zo50X65ylNVZTwXzi13DpU4/G1RRJNGFQN3YbyMFYP3pvAmDohOpIBXYAKY4TURDPSp7uRAov4mJvcpWi07O1+L35wFiIEy6YaXs7zQk2pQdPQJrUQYMLOZ6okAxf0Ayi5YcirrXyPcy3N0XalDOip08TY0nx/mnSr9Czphy+hDc30uz0gV0ljkEdadlbN/rto5CZv7GzcDynIHxxMVBxE0eJLKf4n2vAhKqXlgWUHB5jhRQSHJgEZR56uKHMOVNvruxc1IFcQcpM0UpbBqgZlb/HijSHXWwX3Q6sefrGpm3i4Hs/tb8AP45xtFdR6dzZqcVfHzaxlrF3P9YRdNqw2TnvE+rhiB3BKB0S0eZ4VhcJY93wsDCdP1hmjxjBNMgMqheE/SfdFV8mPqwrx8dAOUkwki1vEcU+aW+gtJSkU2AEU2ZybMuPIqJDHELxGslJBpiuBaqlCOj1Jj44dJ9oIE/mpn0iSv6H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/08/2025 10:36, David Hildenbrand wrote:
>> +
>> +TEST_F(prctl_thp_disable_completely, fork)
>> +{
>> +    int ret = 0;
>> +    pid_t pid;
>> +
>> +    /* Make sure prctl changes are carried across fork */
>> +    pid = fork();
>> +    ASSERT_GE(pid, 0);
>> +
>> +    if (!pid)
>> +        prctl_thp_disable_completely_test(_metadata, self->pmdsize, variant->thp_policy);
>> +
> 
> Skimming over this once more ... this raises two questions
> 
> (a) There is nothing to wait for in the child
> (b) Does it work when we return in the child from this function?
> 
> I think (b) works by design of the kselftest_harness, as this function is
> itself executed from a child process.
> 
> Regarding (a), it might be cleaner to just
> 

Makes sense, thanks for pointing this out! Have sent the fixlets.

