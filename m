Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3276FEFB7F1
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 03:44:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CAFE6B0088; Mon, 23 Feb 2026 22:44:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 678DB6B0089; Mon, 23 Feb 2026 22:44:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B0F6B008A; Mon, 23 Feb 2026 22:44:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 40D266B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:44:11 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C267A13AC31
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:44:10 +0000 (UTC)
X-FDA: 84477957060.18.BA4441C
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id E1083180008
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:44:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZUU9HhQR;
	spf=pass (imf16.hostedemail.com: domain of sanjayembeddedse@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=sanjayembeddedse@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771904648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tg28i2guOUUfs5z9kKCzxt5IH57XwZXvv1yeywJRxW8=;
	b=AHENcKIZ58hYvrgzWSCtcj8ZMiCLjbamF2sckBCRDAAVVzBhbC+OrmSb4XzmI9oqUtA8co
	GdgM6gnDXtSAwo8ibWRbZHHQK45fvS1e8zac2pOIkhgRzKXiks+7oZ76AAHJ7A5ZPiPD1p
	HauxzfryezW7Hp+E/eOHzMkG9DB6L0A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZUU9HhQR;
	spf=pass (imf16.hostedemail.com: domain of sanjayembeddedse@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=sanjayembeddedse@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771904648; a=rsa-sha256;
	cv=none;
	b=ceOrBbjpk1G9jsXH/dMFx66h7uvC4fQerfQ+96wBiGicgyyu0cpmlEwjZuZGhscvJlGEbj
	L3IHF+3uwmnY+bBUvXO1yUtVzYxXujiMyVDlqU3bFwHxtgQWQI4C9k7tlUnGgfdvnOE/lX
	sbJLLPjkMvZJONrfK+2Kr2/90cK88gY=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-824adc96ad2so5054250b3a.3
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771904648; x=1772509448; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Tg28i2guOUUfs5z9kKCzxt5IH57XwZXvv1yeywJRxW8=;
        b=ZUU9HhQRlH1dYaKt5G6Pg3QSRSMfSZvUxm2Zd/9Zo/qp9v12BRxnhNv2OJAk9lTnYQ
         6e4gtunBYw2y1K/ONQ/26vq0ywpg9NmWbxxnYjMA/h5f4T9inmEf18HkYZwgMOl1NlaH
         UEmslFTrFxo4IzOyKayLa2w0nzHYFtt4U/+VXH/Sr868o7Qma+h0OxI+IbiwY3A5a4Re
         qgCBJQtzTV2c7Pwf2eSqSebzJEergL73CbsZ+lkT9leGe6njL38j7G9/uZsrmigJ3vVu
         Zl0kSXawo6EloK/LlkNKwEDtEWOBQ1Oi5aqNYbUBJDB8S3roO0Zf0dvFUiTMbQ+8CFSG
         gYIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771904648; x=1772509448;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tg28i2guOUUfs5z9kKCzxt5IH57XwZXvv1yeywJRxW8=;
        b=ti23EUYTxYf1oVbB2XKLH7xB+cxV5VETn8MAfOcYx//YVN7gsA3oj/CQOpLqnM9Zkx
         ntfhN1CDPOvsH+Kvr6/XbSlkhPtQp79W6FKnkx5LbOO/zkU7GayEEi2ZfQ0W3kr3H/i4
         F8GqKjKaWxcNPLjAigJcsqDhxuL2Ov9QK8CZVPj9Zk+oRPi9ybfw8ZdqgFNzCCBLWdaD
         mVWXOTf2UiM8XosF6xHlHx4KD1EsCphXOMUMPub+VvxwLBuai5kdSA5pqdkxdovrH5rb
         uA7qwyRqluX8al0204IssVz47cNRdKiErIb1ZMF+A4nuch/MgU7ymD/BqTFMAzRYF+FF
         5V+w==
X-Forwarded-Encrypted: i=1; AJvYcCUKcYqQIbLoS6rnQ7gs8Z6x/sIurYcuYDUuQ+NUsp1sNnL8a/31ACj/IMrt691AkHfhOU6RbF137A==@kvack.org
X-Gm-Message-State: AOJu0YydVfN4w4vmJpAw0otVV25SGe18YDVA3ESmlVfnxUFvWv1fCdjf
	7kQjsJF+8+EExxkV647Di897R9zYAh/5a7PaNWE9W7nCF7pzVjjPu5B1
X-Gm-Gg: ATEYQzzJSvMY13P3h72FoNer9twcER7AY2G38q8EuwAfZRe075XKiA0SUuk/OkXic/A
	Ss2G9UrPGqHpKcIu3LWrGzXkzVyDRe08uR1iJFTkNTCUxI+Zl+9x5GguJgPl2hXmxmxfza/vIah
	Wpwru2Wkh9R+yE5LtgGh4tPY4EZ9CYZcDtyDGmcEtTTbEWBRQMv0tY8cA0WWrFJDTACirh61O+C
	EjVDT6fwY9jMyAlt93bh2u09V3kTRBEWNd24Ua53Auwxkihc+2sLGRhn/syCKyWobK7b61JGqmH
	zjVxiq8NJRSGsvzvTJhr8wQa33ApVijYyON0tb/tbD/hPtjQP/jSMT2pXenYM+gSwcpbmPHOVtf
	xm2qpurGar4q0UUsYXPJYXzbtQa69oNr7NxytZwBPdxBYGXeTpG/QS8GbtrFNdF20PKEaZ/WEpw
	WkeW8A/gvG2wfBfjN1xmkflC87dFfXLmd3Jw==
X-Received: by 2002:a05:6a00:99e:b0:81f:31c3:2e34 with SMTP id d2e1a72fcca58-826da8f4e6amr8446085b3a.25.1771904647639;
        Mon, 23 Feb 2026 19:44:07 -0800 (PST)
Received: from ehlo.thunderbird.net ([2401:4900:78f0:4f05::e27:3519])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-826dd86c4a1sm9613947b3a.37.2026.02.23.19.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Feb 2026 19:44:07 -0800 (PST)
Date: Tue, 24 Feb 2026 09:14:03 +0530
From: Sanjay Chitroda <sanjayembeddedse@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
CC: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: drop duplicate kernel-doc for ksize()
User-Agent: Thunderbird for Android
In-Reply-To: <aZxvWlsrueUgWuOX@casper.infradead.org>
References: <20260220124243.3264133-1-sanjayembedded@gmail.com> <aZxvWlsrueUgWuOX@casper.infradead.org>
Message-ID: <599A72EE-58A7-47C0-9F0B-03A908D2AC5F@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3xtbdbg5x53wum9ubnmssnajq3p4aai8
X-Rspam-User: 
X-Rspamd-Queue-Id: E1083180008
X-Rspamd-Server: rspam01
X-HE-Tag: 1771904648-571104
X-HE-Meta: U2FsdGVkX18r7PZNLM5dDnEHysSDVhcgwK23FGMql5uIPCSSUEZRj2NczG3VBKPsxU5v0x5189LYUzE0NNQePbItNf0+k7DnBY0/bvHBEInmswqIp21Vas4e38KpJbG919Prs6PtXJ5rPwE/byerdYicUG0ulYv6Obk/8xU94kDHhiDmoBe4ZyoVexRw2Np+kI8G7bknSY/iuGI5c90TTm99EA+wmToFvilpSwjcBz7Ihmje+HQdIyK33jgl86jlFqTaYkuKFVsst8bYIJUziAiW6YDbBxT67VlX8syQxTzV4dhf103GQwcdniB3mVCMR0gl+MJmYlzbzZVsH9eW9PtewE0XttB2/9V9HwgztWWf8zPZ3SjrYaBOy/GHYa0j+DZMbzNG3+zL1qqrGDrIvwnIk7gATWq0IONhX55L+QQFL7G06kc+aT8AIfiIOECxozVXI7gZ5D5fNmZRxqufsbGL5DjVjqPETCWxR5WL5S3Xtb80oHEA+11gzHOanfIz+soLvAzszPx+xSSLXsab93D6zCLgw3TV2pweaFS/S4s7S5+PhVzPmCRg8YjnFIBYARBs4yzlhsqeEL5sJ1o6Ig5MP46LC3IuqW0BW5q7wMicr0BhuPM9EHi+VZUUDNvDNlSUWLdiTnwBUu2VD3o565vOe5QIY+/uEEEnxItSS2dNDT7+pbFOxUp/IURvA+BAZui4O5zdaI8QMpKlAkwbtZNFjPUm3xhSjfWVxord3DktCaUZ/nIL3ES9JFWYApP2lFSSw3dZndXiwEEqgDfOhZx9Eie2s7D7rtbPeVQzbG2S+NtVG7wEanKaehcYLSbUG9FeHFFCr7fIAbSEVWJAq/PDv7cR4Be52ExwbjUeEg0OVWSeVR7cyOLaEruekZ4E5eWQgCZ3dtPG43VCP+Rt1zE+HqSQYbYvQNOjcYk/nwAIzS7CtvWOg0H3TY1lU3J1FD0HbynNXgQOuiysvdS
 e4goOWZ9
 ZHONd3YAtSoAZQCIArFfuEjIQ2wtpbFSZJlCxI9ySzGo/cl3MQp81BYwM3Qd2mLLRloekCDfJEqdDjAK8foZquTBiLU419acMuhbDNLzWUzYu559k1Y1Tlm1iRrPZgJzVpqtXzuGbmdZK1glB/ilaFi01U4aANDJV1XZogP9MBJOsXgU5Lop7RaelE8cF1O6FLp8zxgKPWvSVn/Z2QRd8/zhU9FuiOUcRbYirlw5w64M0W4reiOPQVzdlUPAqm152k7ZXT0zcp5lo4nDAR5+SUaR+H7oWhU8pfWP6BtxpWfpfgwWWXI7TnemvxJe9eYAhSzxv3xyrJ3edO24DVbi89UyVMaQwB05wR7qfUqIn5tqK4f06t3idGjM+K2eX0TJoOoww3YvWFKFDrPWRxxtZ9ijKbP81vx4oh0rdgjX5STroAdKQrFaM1qz25Oqr3rUt16EiGYNhN6frwyBdeVxl6yIlQ2AfBrnlw0oVye3x7r6P1N7IrMrLeDxOBjvXJBS7ToPM4JBKkcHzP6PCu3Kd8Y+Evxd03DXbLVehCuWJP9C9tJrUvsW2MJ3VyxG4PiA+fDmJCHU5m5cEVFv6Sm4YHVY7wdxReMiIQKIe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23 February 2026 8:46:42=E2=80=AFpm IST, Matthew Wilcox <willy@infradea=
d=2Eorg> wrote:
>On Fri, Feb 20, 2026 at 06:12:43PM +0530, Sanjay Chitroda wrote:
>> The ksize() API is already documented in the public header, and
>> Documentation/core-api/mm-api=2Erst pulls that canonical doc into the
>> book=2E The kernel-doc block added to mm/slub=2Ec by commit
>> fab0694646d7 ("mm/slab: move [__]ksize and slab_ksize() to mm/slub=2Ec"=
)
>> introduced a second definition for the same symbol in the generated
>> docs, which makes Sphinx emit:
>>=20
>>   WARNING: Duplicate C declaration, also defined at core-api/mm-api:521
>>   Declaration is '=2E=2E c:function:: size_t ksize(const void *objp)'
>>=20
>> Remove the redundant kernel-doc comment from slub=2Ec so only the
>
>Usually we keep the kernel-doc comment with the implementation, not with
>the prototype=2E

I agree with you, Kernel-doc comment should be present with implementation=
=2E
I have observed that multiple kernel-doc comments are there in slab=2Eh wi=
th prototype, would you suggest to replace all possible at once ?

Or with reference to reported warning; we can keep kernel-doc with impleme=
ntation and remove from prototype and rectify commit message to highlight i=
deal kernel-doc practice along with existing commit details so context woul=
d be better clear and relavent=2E

