Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95460606A32E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 08:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=Un+5pL9w
Received: by kanga.kvack.org (Postfix)
	id A96D56B05B8; Mon,  2 Nov 2026 03:27:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6E066B05B9; Mon,  2 Nov 2026 03:27:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 984766B05BA; Mon,  2 Nov 2026 03:27:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69A616B05B8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:27:38 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE320A893D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:27:37 +0000 (UTC)
X-FDA: 85389500154.30.4826F1A
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id A3E7440004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:27:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Un+5pL9w;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793608056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ryxS+aXyH1s0wbz8aqQ7n2ujPhXRrOEtxD9s5b9+KhA=;
	b=V925KbmTlt2f/Ib4xDvVJ3xvJNCGuKtqeUVbr7/mGzsTztmBY8JJppiAgMIRjJJ32xOiLM
	KqkRDGYg7Y29cBPYCq336MK9pTABmwAfeaVZptUGzisSNmk2YBVWJC0j1EziZpywJAPjpv
	D9rWj9PsxQhfxq1neW1eXrSoNf3BGsE=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Un+5pL9w;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793608056;
	b=iZ+1osKB2zZ4qkJ+614gBXPX+alQPDWQzgODgIdZ7IkmeIHrx8obMXPHjGhvvGvxFncVst
	bQT0c0xYiUyDhkESBps3r9TrYno3rRMHkC5PNguo5iSesmO5+mv+1nOJ6qUy63mURgSW/W
	jmVrp5SIfKmVq/mClGkYGeqp1DgJBBY=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c4395d31228so415060266b.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 00:27:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793608054; cv=none;
        d=google.com; s=arc-20260327;
        b=PoCgvA/JvF5z9bUiOA+8bfqQWpyu5c8LNW+714pOCdJxABPTKnBogEmZSHhd2cxEqo
         t2WRdeYhMzidHdBbkjTFi6ioRZZy0CY3K9EV+FKZojvu9SeBxXBoS75NRMYOSM7uZxrH
         tfWE3p7rrWpBtmmvzNEynqVjL05po0WsxPOAGz/QVEyiuPNvPqXf/e99yCUtUwNyMd0+
         sPLHWfsopFgWX6/srj3NWhHyetM/RUlK0iS7/JkvPHJkIf+dcfImzN4RIERO9QLw4WR5
         ZOsG0O6ZvZ23btJ50RP8nBz7sOh19fmsdNtCJGFSN+dNumngd7y1eRs92Hev5Q+BdvXZ
         vcQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ryxS+aXyH1s0wbz8aqQ7n2ujPhXRrOEtxD9s5b9+KhA=;
        fh=BCxZcqJo3lcMNl439aFfve1wfRWdGXoBMKNnQR4Qtqs=;
        b=Wxg+3agvCRQTnJKAYH1mcJq4SOh9YPFroQr2QmUPQgK7h6g8T/Ndt3DjaYSYCP31D0
         f5izDaKIzURfU/CpsHhSa47ZkURC+3aDFtDkC/sSgLi5N6pg1Iv3GpGwLCFpEISozZfX
         Jm7EyeoYcluTCoWqBio6nQt9ACVo/8OphkhdjH0OngMZhRYnMRCUuIp6BhRxK4WJY7Sm
         mK0QrLhN1dlXzvq62RftamYssnwZaFlnkpx1Ies2gLmb5B0IPICTDQq9+XSjCnXNXONI
         TeIF1KohaT/FFlUtw+pe8YcEFDEYAlRS/AcyTsxGy4SkNVtoRSKTisPMvuOcXfuqKDQo
         XHUA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1793608054; x=1794212854; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ryxS+aXyH1s0wbz8aqQ7n2ujPhXRrOEtxD9s5b9+KhA=;
        b=Un+5pL9wiNMUBBdPeTkxr8+6pLOmqbuhVFcPTQtlpjQYl4dn0gqDRzYj/IlYy1FAxq
         mOPtXD51ILX14zpN0DvY5kpRjELQvXwMgifLj9Wdydvl0YVH6NfGKYFzx14NdBsd6cC6
         OuRc+VmD+izgwH/j3U+ngOZ0LtX7o2ov2sHr6PtHqPnK2uDJ1f1HlXj20h3VHTFjYzMN
         l64YptL/wpWHpPlEJOUduwcOAGRxSytD2Cytp5Qrhl0fxI+y0wCqfCuILF1qf9xJ5GgV
         rx8GkaLTpZ39RrrCoiy2OQ9D2jGWFsZJJTjYLfaB/IbrdsvgaAGIo/uQxxrHPEGk/7+4
         aWNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793608054; x=1794212854;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ryxS+aXyH1s0wbz8aqQ7n2ujPhXRrOEtxD9s5b9+KhA=;
        b=AK2CCJ2RqpAeFvTpKylWmzyF7lZvmSTiCc0XlxkdJdc5q6FGiVZIdmMgvaJB+y/D8Y
         XRX4pzHw5mgB1A3/RiGgwwcQoMP3+J61NNe2PKxDRy/rXecaz0nNJ3CrbdfWKGb6dS7y
         tB2c4GCZubdMr1pRHDNvXo1EAlznC4r/lX+GU9Ik2UHqrKChSKMuMXwFWTinKNhpXno/
         fbH9sR1SbA05XEyczDs415Rt/vCWp5J1qDayZA5HwmfK/tJ6Wxqfo3steVLQCx9F1IrI
         16hdTvW98wQ87heu4q/dTbie3TmDszfABvfs6ovtLhLBdbcwgsP5AIQENJkPnqLXxDF9
         TVXQ==
X-Forwarded-Encrypted: i=1; AKwUvBySLR48ev1UzrsJZBLVj/n6DUKG+InN4WzV3LX1zeifVbu2NIWr1Qgj4LLfPhRYKWpzPaiTuJxNog==@kvack.org
X-Gm-Message-State: AFq9FYI8P7Y87oTPnpNhE3yfPr0tUCPAE6S75PPWCjbSJoeN0q76DW5y
	iuobIB1WY7iGSaMojwIsZ8EQFsRuRLniMhIuW+tALctmLG1ZfHf6Rl+HhfdI6WDjFsKYBYptXzt
	v4LByXINs/aEnMyjQZfXPnisp3hoTynO9GSixdkRQYw==
X-Gm-Gg: AYBFou3nUnOh1hK5BazI94MQlquuBdey2tcGLQhQ9nNKc7/ofF87ur07WwpQaWYp7F9
	aDrc+cDqCi0hjxlvJ4vNPwqZnJOf42FAr27pDAd3yTi+PrR4GYFdVPmD2w2yh+midvyfXKv3w39
	aKtPQb9st5XyBVkfKAtCzBcPw/RrvO72dtAbWt0owPHYzD2b23YqKiAWz/cFTOH3IDpcA/LabHA
	FKeHI4Iyx7dNjftI0au+2EZLMd0pFptuX+pOmheY38nN7f16knlQ4VinCbLyQnnJXo6DlVB6Ibu
	ipgAdBDRSidKg61QDHxIe7KAYzh2jrD93vB6hTeJOsNV66vdW25/RE8oijGvUszEgf2ugJij3Cv
	5pRhAH7YMuMVU+JkXYd+rLZgqo8led1xJOeL7puMkuZHPO/MwRgAxT2wVkWFGXoFjdw==
X-Received: by 2002:a17:907:e84a:b0:c49:901c:d9f with SMTP id
 a640c23a62f3a-c4ca7ad1408mr835701366b.49.1793608054397; Mon, 02 Nov 2026
 00:27:34 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261012205447.2717801-1-max.kellermann@ionos.com>
 <20261012205447.2717801-3-max.kellermann@ionos.com> <CAGsJ_4zQh9HrvgaqD32_A=bSdqmPqP4oV_SxMXMEDBrHe4jjhg@mail.gmail.com>
In-Reply-To: <CAGsJ_4zQh9HrvgaqD32_A=bSdqmPqP4oV_SxMXMEDBrHe4jjhg@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 2 Nov 2026 09:27:22 +0100
X-Gm-Features: AclHuK-DaFHs4ZKgRnNWfWDrr2HTqoXucqchR8x0CYIHHdv-rb94RL4ugZac0MU
Message-ID: <CAKPOu+_coR4Z=cbsWOG6zgbSWGvmp4=9=uUphkC3TWTTGn0Pqw@mail.gmail.com>
Subject: Re: [PATCH 2/5] mm/vmscan: move code to lru_gen_{add,del}_memcg()
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A3E7440004
X-Stat-Signature: h98n53ts7sd7h64711k56z6uxeathgji
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793608055-666174
X-HE-Meta: U2FsdGVkX1+wASXuMt5pOaHJlDAoBPesxQ5SpSkYVMosGRP0jCifvwXzd8hh+lcZblEQ3H6RC1bX3ecJXZto7WsjQZbljjN0xnx39bAZTjSjt1Hql+IvYHmXsPw1GlI/kJLAVhbk9EwkYeSlSrQXBE7n75pUS8BkvUpXayOiHC4cKqA9NqmCZy1i40xPsx31E07H6oF/PgMvkHAv65+LeGo1JX9DL/4gGQvP6WMPq4qIdNv8tMMY8EoHwvZyv6wYeQjVk6f2EH+tOmCskr2OX274TY/bmZdevAZSyMAlS+t6yHLT92bFurB5HPQsiq40bmDxXi6EatCXQelqPQbTPRCvIxpiV9m8R/ycUaqnfOkcRs4/iffelewjtHa1otaCsE7tW8wwACKyYZNE3UvZNu5mvEA4S7TSgTPwptyqZLLkQ8DhJkhMfWDLBLUYXnxneq2ajR53/83rL6yNwRo6ifESr+145iog22DUBNXPzAfXOq0XDVkDnSIMbrSYAmQ5Kg1V1l7w2NX77yYizD5c4xPUahe2tdUO9gVKHqnBbgLoRlxrIfh12tfjobF+Vml8oLzSIGihKUsSD9HHfRdec/eJH09orf6qBjagSH/4ytJVcbnymCPZZIQ3sqlAPj0ZEHcf9dNswe1butVlwlRfe0MXcyFSdcmLiuHIg2+jskfl6ZmRDn81eqemHP4gWFoap9PXPdA7kv2eBx3xnSR/s57kpvgX6f+QFWcuMXTdsHUGz0u/TGBOAcftzQMli1tQYUu+h14H/M4+/hskIVYCbZA7vgzrzYppReM7dkeHqbMYN8Nnn7BRUVIW14J2zh/cdAyaAU2zU7YKubf2UmEV4yjXup7aESiyagkn7QERW+OFSAWg7cLT4H61oNwiM3jHdzhyJazzPeb5H+x4HFH5l9d3Bg9K7kj01pYdVnRR9uX+GtfQDph+bLNF9DSuSiGrl2HIobHxhZ9M/yz0XvB
 fyNNkb+M
 jQLCeWxIIGavZlhINlwAkgLa/Bieh6LGRS3+OuDa5YgvW4vGCxseOcn71Mwg2aKYeD3Y9plB5oce/ROuBgGhFqwR5J1Oh9nAdw/ie0uxFazp+fc13O7BHJQJFtJzOuuyNzBtoR1ZusKboP8W4q0pHLgbpAiL+Se/52B5SaRpuhA6CnzdyTZgNlgB2t1jzc/KABOCRd7yvQTu+6NlqroZoyRoY7BG6FNEKqqMA8v/rpQ+53G91I2SLMao5hKQBhQMIHL74+YWokGPk4QnESWU9YNK6q0FSAvBZfzyNvfN8qCyMymHnaxYaLQWVlYVsA0GQc+wAjb0a1rbqJFJT/24imbuLWADGNAXZwHIjrXU00zf48Tk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 1, 2026 at 10:03=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
> T.J. series[1] removed MEMCG_LRU_OLD, i guess you will need some rebase.

Aye, will do if you decide the series is worth merging.

--=20
Max Kellermann
Principal Architect
Hosting Technology

cm4all | Im Mediapark 6a | 50670 K=C3=B6ln | Germany
General information about the company can be found here:
https://www.cm4all.com/impressum
A member of the IONOS Group

