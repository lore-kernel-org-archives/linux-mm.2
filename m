Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CA0CCCFA05
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 14:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B773E8E0086; Mon,  3 Nov 2025 09:50:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4F7E8E005A; Mon,  3 Nov 2025 09:50:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A65828E0086; Mon,  3 Nov 2025 09:50:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9558B8E005A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:50:18 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A35F1DF5EE
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:50:18 +0000 (UTC)
X-FDA: 84069581316.04.BA138D0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id D8AF410001D
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:50:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ddPEAzOK;
	spf=pass (imf14.hostedemail.com: domain of toke@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762181416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+nMoLQg870a5vLIr0xXAcHBID4BH0thIsNlUoCS1bvw=;
	b=yP5uL1gKL8kJSkkacZ3cfEBgiB72Rnz1zgMIUFc4NssBMOXmEPYj7918J4TnTZArBBrXuS
	4eWgHK3+QxKqTibJPntmyry1QAYtTHMMOJPsPaz2fU0cYVq+d4th7Q0nrxRN9NiyXuNin0
	JLoW895qqGdUAaKqXzLS9Ym/HIFDaJI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ddPEAzOK;
	spf=pass (imf14.hostedemail.com: domain of toke@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762181416; a=rsa-sha256;
	cv=none;
	b=bymFGrTPiWjz9zLB4rZuTQDi/RPm8A+n0Z2M0ps25QbWL7VNvgZwcProEbJK/sJsHnujhH
	6Ew4amyuvXebLezci/uyq0aDkZHtnBdogMbyihljoDUa2WvRJFv7I2NNvMufy0L5yvIRAA
	6lHs667NasyueAOkR7/Kvzqn7JMOQUc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762181415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+nMoLQg870a5vLIr0xXAcHBID4BH0thIsNlUoCS1bvw=;
	b=ddPEAzOKGCXocCQcptdFyd20i4zr+hWdawWw1HYsPyLW/9LjT6qwVwBHtymtYxWUw9iTJU
	fPrMS4QqSkT3dDGQftJKABh5vlKJXcsFNaUUlfuKFXXNl6EDoPey27uviQ9XnuRU5kwSOF
	GquIUxd2lig4m13J53Dtz3/3BSoqer0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-GhJ2VaCwNS211ZcSd8sJSQ-1; Mon, 03 Nov 2025 09:50:13 -0500
X-MC-Unique: GhJ2VaCwNS211ZcSd8sJSQ-1
X-Mimecast-MFC-AGG-ID: GhJ2VaCwNS211ZcSd8sJSQ_1762181412
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-640ac45f840so3732116a12.1
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 06:50:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762181412; x=1762786212;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+nMoLQg870a5vLIr0xXAcHBID4BH0thIsNlUoCS1bvw=;
        b=ssLl8InoW6jvaQ5GdGYzgwK2/JGlT3U7A991dCJnCE7JxxZRQ/2lP46nyWuIqBhbed
         d2rzYxtffwbwHkQxUe3g+07KhmYCYNeeVhCLVbw/87LF8OkhxSb7sTiigRMoIhylD6ay
         wwP9V+zvXtWN4fkqzEACQg0/b+MFp5DMJiP56tk7Gr1Cx8KNLiFLJdPCLR9o3L87swXn
         ia6PA+LQmiEKGuYHo9jPHrmaBS6n8mx81NqpAa/8D7UWP277LYQ9zPwh4tzwS+9zsMsR
         bKbgidzLi5HZ54PCG743U2oaNC1TuvyGQigHI5Q6bFNnwsmPyVAiCPeiJcJ9LP5QqLDp
         3jew==
X-Gm-Message-State: AOJu0YwFzZ3+pMNd5NydJobxXymuR+QSgCXH8MKkRiUtigku6biOz2Ji
	YLc9N6PlSQsnNe284MRbexWq3h4i/T4DMSPNSbeNUSlWXVbqXr0SDaPm5Mrx3FxFXUCPK847DVK
	S4LC9j/odyjEJTcZX0WiI93dF0wah5jXYfarYodUPO9ieY48Wb69J
X-Gm-Gg: ASbGncu4fZ1/133JPAwv37wamC147jMF1mfTCrQbCJkPZaUyVX5+7u+QGzzOFH0nYtX
	PuSfCwHNqM1PXHk9TpKERn1eqqTgo1ta9aXXLjD6A4/rq9Pe/y+hLgoVjrlYy8p4nGXIS5H1iIz
	X3tSxBy3P9Sb0bMh4UjRs0KRaLo2dQU/keQLt+hkCoxuoc/7e7YyEUtxhL+LcMjRDnnOnxiI2qH
	gRTPK21C3amffoxh1WA0oz6sRfVvK4YOiK5iX68zvVxMYYW7nAoUM48sv1wQiu8C+E1s0eHyzFd
	ii7SEnJg5fc7R6lmOrnhWiKGlkQCAmzBxKXt/WxlW2ge2tlRTSdJUgokhnoBjMlEMrVe3ylccJX
	65D/AK7ygPRsJ3thdx8UD6FU=
X-Received: by 2002:a05:6402:34ca:b0:640:b497:bf71 with SMTP id 4fb4d7f45d1cf-640b497c2admr4755532a12.8.1762181411924;
        Mon, 03 Nov 2025 06:50:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHNHHGCfan3xN8hz0VQLwH+oMIT11J2vhXom0DZu1MBhk6Duw5v6C2YzkNLZvnmt+vEeRS3LQ==
X-Received: by 2002:a05:6402:34ca:b0:640:b497:bf71 with SMTP id 4fb4d7f45d1cf-640b497c2admr4755480a12.8.1762181411457;
        Mon, 03 Nov 2025 06:50:11 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-640b977e6acsm4056741a12.25.2025.11.03.06.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 06:50:10 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id B7D07328476; Mon, 03 Nov 2025 15:50:09 +0100 (CET)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, horms@kernel.org, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, ilias.apalodimas@linaro.org,
 willy@infradead.org, brauner@kernel.org, kas@kernel.org,
 yuzhao@google.com, usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, asml.silence@gmail.com, bpf@vger.kernel.org,
 linux-rdma@vger.kernel.org, sfr@canb.auug.org.au, dw@davidwei.uk,
 ap420073@gmail.com, dtatulea@nvidia.com
Subject: Re: [RFC mm v5 2/2] mm: introduce a new page type for page pool in
 page type
In-Reply-To: <20251103123942.GA64460@system.software.com>
References: <20251103075108.26437-1-byungchul@sk.com>
 <20251103075108.26437-3-byungchul@sk.com> <87jz07pajq.fsf@toke.dk>
 <20251103123942.GA64460@system.software.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Mon, 03 Nov 2025 15:50:09 +0100
Message-ID: <87h5vbp3vi.fsf@toke.dk>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7s62DLSEcLFgGU_9A-h7Kfz1OS1X7k1_7pFc3_zypGQ_1762181412
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D8AF410001D
X-Stat-Signature: dasnproi7uhpk4rj7gewss7c4achayaa
X-Rspam-User: 
X-HE-Tag: 1762181415-779608
X-HE-Meta: U2FsdGVkX187/1CAD0Sn11Rt25h4gmH2KSuze56FWz2oNKh36e3fyPNSDzM5WGUUbeIR8wgy+WWTOZp7QPxHqJWw+e22mpG7eoE4v21gNEpsSz0H1TbSoJrBzKsD8KhL9OLRK33XE4llPZK0x4CFLUiyeuMhTonUcCicA3ok2vLhX5c0RJpzhlo3nDAvtF/mUSyJxo72jwJnufYfD/XZP/snktcOd6mZATkPReTIVx56IQmaQvPJMK31S4bSOX4lMqvplHM4Wx0qQ+OL0uUQCMTgSHtsctPNV5BEySLGwq+QVLbTrWAFnoIE4rejQaMrnaCVr3k4q2zleRfXxAqVaS26FmOfaFSO8KETiVaxja+XqAi8rlc43axoMVxS0bKTNlZsbdhrs8vi2XX7AjiL0PgmEbaCQm5jUiSprD9nsY3ioYFq+akU7xafEltPht58AAe6gXpjwM+bcpjRLHohQbMONbwGZ50MPxQ5FaLvvBq06OiMZ312AQq+PVSgETrAmWbeKuhiv/bNtd/BVCR9zpM598/26iz5ol0uFsVTmbvrixbRcOyH9P66f6pS5RiECRtN2z5L3vH2D3172/OvLVG7Ryb8NvoH9OoWLGiIMxBAquYXAKX41AyqqpaiDL9DzzHZU9OXgtvtBkwWGMT/mLVn4eyY5VcYvQmlJssZ+itqpmSF0gv0u4YqRPPKlURXuN3D6QDA3a6tSfBJ5sDEGE0pfGZZBrWStH/RbIq3SopHm0KsJRLuMDH5HCxjFRVI8ijnHSyAh7Ippr+Wa1U7xRe89882eGKL0zgbOe5mZtfLG29JTm1B+KZOApKNQm69WCAZ4u4OxciIgqhjaBE/vbcLt2wSVfXIjGd/kJYXPw5uibptEZNw6LRVBlqJDBbgMOFpJWR07sl1gpsOosmSHmmSVDfYBkV16/cdVTEu+8N3nzOmZe7I81SWC8BIg75EN1fYMjAVLd+sxeZqJAS
 o5NL4+20
 PUf1WT+xuN92/yrLKm+ae3EERmz6cwR4mPk4cjqd78iwWhnPF7aNFDtPVIkohintdddZb2aSpXTCktXDI5cn95iSEeeiztDqBKr0BnGMQxe0ETFS0gCTe0zvZzTZm6gKT0FIrA4y4Eovm2/hIpyueUqlJSjJ8k3Hnr1CKhgaJ4vymkm4ucF/efV3wxNCDG34crr2sR6OmfqHsBilE3YW2Ffztq3qihSsU8lR8nVrVx1ICVXf3Hd3nG7FmD3ejN/0YRIgznoN6vsPN0va4fzVJxkbPc+zXICabi18jT75tKRSrvRKkoSc+rVSwrb7IZKtohO6X7Iih/mq463xrUvLnWEuL7RdpKsxvay+RRP4yk/OdKrkYxVjzBrIjq0bfEj/kcBOipDKWIceY336S8psydIz5083JU5WBOmuuwV0fKBhatZHQsJDzbc1mkrulSVJZqJKrbZ6Kz7r/R5eiINxKRyek4t/g/tuWaRvrox8k3H0KxkeKoTH/yYo8QKoMozS+69yUAZkNi+VUyps3gLLd82adqNnwhRBw7D8ziyungOL6Kz/RgBG9m0ZkjJwXEx8LzMRs7vFSb35v45NprId9lRkoVo/MXg36AAWWPhl8PL9btdnocwPrVeuo2Txv23QfhIVU25ZC75R7smOPOwo6Yd96XA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Byungchul Park <byungchul@sk.com> writes:

> On Mon, Nov 03, 2025 at 01:26:01PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Byungchul Park <byungchul@sk.com> writes:
>>=20
>> > Currently, the condition 'page->pp_magic =3D=3D PP_SIGNATURE' is used =
to
>> > determine if a page belongs to a page pool.  However, with the planned
>> > removal of ->pp_magic, we should instead leverage the page_type in
>> > struct page, such as PGTY_netpp, for this purpose.
>> >
>> > Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(=
),
>> > and __ClearPageNetpp() instead, and remove the existing APIs accessing
>> > ->pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
>> > netmem_clear_pp_magic().
>> >
>> > This work was inspired by the following link:
>> >
>> > [1] https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@g=
mail.com/
>> >
>> > While at it, move the sanity check for page pool to on free.
>> >
>> > Suggested-by: David Hildenbrand <david@redhat.com>
>> > Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
>> > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> > Signed-off-by: Byungchul Park <byungchul@sk.com>
>> > Acked-by: David Hildenbrand <david@redhat.com>
>> > Acked-by: Zi Yan <ziy@nvidia.com>
>> > Acked-by: Mina Almasry <almasrymina@google.com>
>>=20
>> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>=20
>> IIUC, this will allow us to move the PP-specific fields out of struct
>> page entirely at some point, right? What are the steps needed to get to
>> that point after this?
>
> Yes, it'd be almost done once this set gets merged :-)
>
> Will check if I can safely remove pp fields from struct page, and do
> it!

Sounds good, thanks!

-Toke


