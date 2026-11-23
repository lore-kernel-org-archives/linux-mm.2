Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B73A606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tVRl8AX9
Received: by kanga.kvack.org (Postfix)
	id 7C38C6B05CC; Mon, 23 Nov 2026 12:38:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773C16B05CD; Mon, 23 Nov 2026 12:38:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63C466B05CE; Mon, 23 Nov 2026 12:38:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3910A6B05CC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:38:36 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B4C15C09DD
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:38:35 +0000 (UTC)
X-FDA: 85467093390.09.8794343
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	by imf11.hostedemail.com (Postfix) with ESMTP id DEA8E40007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:38:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=tVRl8AX9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455514;
	b=e0RFlfnDidfcen3pri0Lnh6cgk6LAQrqpNJyMBQNCImBXjXx7Km9nsUpByeLz5+dr49Okd
	ikUibKTRP55QIdlAw0/YpxB2d44xzEwiH/WVBCB0mvcTY6lz2bOBowXXrBxScFah85W7OX
	qnrztRBmlZv+qEyelMnd0t0VGdTGgIs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=byWegylhHUbUWvI71Abrtjm94VdQoqKOeR3WzBbTjQM=;
	b=rwFH2Ms5R/mw9nup16ftu4kMxTI/Py4h8/MN3L4QGvyf1jzS1s1wcFXT9Cw9QLPt+qBpQ/
	GKhlJuojlKRCEA627n0ltmaTQMN0ADNNwQo8RlmQBfvMis4dIUaGBwfp/UIliIkhkwWGx6
	zuwty0DBsB8FkN+D/6w/HIp4orj8Xyw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=tVRl8AX9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-36a6ce64b95so1376457eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455513; x=1796060313; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=byWegylhHUbUWvI71Abrtjm94VdQoqKOeR3WzBbTjQM=;
        b=tVRl8AX9LnXmk4yAXFsoenujCzRw4E2Z3qMLWbLVDdKTTRoRm/vVnTfVLXRJ7AfTxj
         aXtI5+uJmjdOw69RW5NlZha3JkSLQxdw4uzXOR/VxGNKQZ0J+dOgp07AIF1F92QqEbjO
         xNf3fNmQHPTIkcX1cu3YwZmB/wMS7ueek0MctHO4qrOwuhyP8OZJVpHBGYgkbcF9L0w4
         swlGhAMZoMQBsZb9VRa4LVs3e1GpXU+Aza0AEgHZIrGO2My08P7fBiAMQaVnsXWifJl1
         bDRrjvC8lCNR4CywLq2LPvpjrxmc3I55lSMwWW08zlPHXrPEA9Jgj5M/maU851VCFwon
         3LYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455513; x=1796060313;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=byWegylhHUbUWvI71Abrtjm94VdQoqKOeR3WzBbTjQM=;
        b=JfORRwIE++xaUaCEAOPeU8I+McQnZ5Z6oow879wgGo6WwxD9ePU9yYLSAm0LaLbKbS
         iIY5si1H+JbgIPTc5cw6/0QgBzzHe30TMrjoJKuh71vqRX/9iSKJ6gsg++VFR3QCWY5x
         9Yz8RmKgYWBvvme4KyYifdOLFZAJb/AaywqntngHVhCJVQSoU4t9Ww3P4c0gtwiwt7Eq
         EYyQJtutKiBrTqjoew7UvFFYFxr+nP1x4d2VxXEexx1HsAljaH8Wkg6tkWX5rCJxzZQW
         RGR+usnk4cJVmuQyO5rWq9wlxdSy9GPZSmsgYdZYB6io0hJBxDdcrTxjKbCp3ibhuZVf
         fp2A==
X-Forwarded-Encrypted: i=1; AL+hErE47rSd0m4Z6DyctdfOfl4SU2lih/9UAJXrRASxrF+fCYFKWGTCEtKswMR3TWF2GrCrc3pF4RvQlA==@kvack.org
X-Gm-Message-State: APuU4Z8KHHZCZuYwAEbSnmg5nvvnqLYUwgqbDZVgxyN8EW4pTTk8Z8dc
	huEabVI8Kj1EXFZUmwBpKADQajw1hh03u7gkODHxAGn02PA20wiGhSqY
X-Gm-Gg: AZFdTZfn4nQnhf2IXIEusNqunp0OKCi/EpZzk6B/RWz/juHTsBOa1qSC4AR8NlUNZvE
	9G16hQ5wzbKIK9SacBVgWXBV0r0kZq5zOw/dSkVZVxP3+Yeko5Zok35o+N15/4nz0NPxtVlxGmg
	RfhgJh4OGV5eU00+/y9He6X2LS5Wc9l9O3LAsSdv1eWwMU2wU6QcjoUBEk5+B44HnsmR0rwe3eR
	TxnSeU/wisT7NMU/1slVa3BaFpZNqSwvMfqMW1GuEsN4qofBDyI86sGNEm5MFwk8OkTcKllm/YT
	nG6H/nt3WA84KS1Xfq/jTbCzUEtgh6XNUsCU615IZ4zCzqyYhhzDP1UdUf3BSNsmLcx9+NzYa3J
	lwBlrxHCzibLsRtyVKhT0dhtYLjI3rf9gGhB7bGzanwbZybscGOam56SUpBeHWD0X4eLVdSnF/e
	pREVV1vK6lQr/moKbxRiQ9MkLKOgQfdApzcBaoIPHpZJCODNXt74blJmvGcUfTRSjcC2wtwvb+K
	jnn5cKI76ZkwIJdQuovBEAFMzMpa6jiHPFinnfx5KBUpgo6rqf2BuaPM7MzOHh0sFau0Tk7KVKo
	3xY17htV40Q6VoQ0A0KYC4ijeuA6ZY1npFkKoqYKo8of5A4FcF0PIAkdAa63J2yl9bxxPBfUeQE
	2CNqE0+05FIFIzjXD9mx3ZEljje+CZoTDtdXjE311iTGiAUAocMr6y3P2VWJtAw==
X-Received: by 2002:a05:7301:3d19:b0:376:ce6a:a499 with SMTP id 5a478bee46e88-3857122312dmr17032452eec.36.1795455512534;
        Mon, 23 Nov 2026 09:38:32 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:38:32 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 23/27] mm/damon/sysfs: implement submit command for
 report producer
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:24 +1100
Message-Id: <179545256492.4.15675648652797280437.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 linux-mm@kvack.org
In-Reply-To: <20261121210013.130397-24-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-24-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: DEA8E40007
X-Stat-Signature: 3hotsazbpkfr9ypf976xc7cd5sjuhcx9
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795455513-787489
X-HE-Meta: U2FsdGVkX191IbJ0WozAMn88oy9nN6hT1Hl6N7Bl6tuMj6Ta0CXIyybGnlz0WbBgBiOOUEBpYC8zJt1MVRa70wOAI5DNkzjLhOEN6hmORS3V57g8p2je9FHaZAoHmVDwFAnWagEUSteuGbxnAaVeHzkeq3NtvvEXupKQtn7ydhzTzNSMIOFDlpP7kqYYQogmWhe8Vao7EkpJCjvPJ8G4BW5eUGm21dpArqklHu3CvMHnyMwvzK7xckg1mebwjo6KYOZrZJ1EFWgiclH4msUmQQqUUGGcz7hUehXIppqCwQ/o4uOMYd+csRKyXjMNjhP5q7J4ZTKvnBp34oiDgM0tK04lLbDIOVj4Zwag50Lj87nJiZVbGSGX6zlpwpAxHFpDzS/PVexUZ16ZgYCyWRJvdSshMZ8abYKOytkBYZOyznyqJaf6WAImqJ6o735ioyoGuhm2byz3E6rldgTnyTtJmMMItEHbl4Yn0zABpY3RqsGsatEjJbVoiVmfSItY+rlpSaWa34FYpbOFhPllCI0HfoxiUPqTpGSXPM8cNQt7RcForAS066mlhbHu8tEETZYkFiv1QN7PMPPFzYxMeeJt9WrUmy0CiAbjM6JBXNNY0/m72QmKccQmXTzT95LwLJEtPzNZCFEMLGYiB34kJWwfX4rrcjy/gNXhl40XdRGioZMHClgj4XaPSRANnjwy+OL/j8yDC6Ml23aVeK9YcSRP+DJ+5cBkbwMmA4yuwHttr+RtkOo7qOA3E4odQMbSBSC6pnVfnbex2c2n7KrroqZ3v5toYurpKYpiKWntiWdSVRk2WFcxzIDRrEc24Zg38PULa5F0ncNwAq4FuM0q9YQBR6TinVG9DkJKJeFjGlrtxgCnGVu8QqXQ7BfKKqIui5FrSO32/z4b8X2XAsVj7mo9kAFPZm+5iiESJx84mQXxfpBTWhHpnHF2g7ACB0Wk98rSFtloXrB9fAP7jmDOW0B
 k2C+9yCt
 9d1XQ2QE3XhuVerYjd5d9QeKRq9noTkP3T7HLiWlROW6q6e8icYKNr7kwDiM4xfz1gl0ScKrsiZkxjU4oXVpkwf5xIePxOBQOLxObyYGeX/SKCy+ahprgFHY6nhObUgUm65ExR+uVAVAbbPj6v2WJ4bqg+e7ralib0IN7cPU6g1ynybS9JHD8buUr4eVG76A0B+96picwGfZbCq/FnkEcziX3KcnpEzmlROeWUDAP2pSrA63TlvVQVlW6UPvI+w0N08P7HgXnTYqQuvmoH52Jicbtq9EsAsheTYgJ3QDEy/suGm2SHIfeanPmURTuzZtXXGqSET2HsH47WKbWV5P8vzEZVCm2CHim61v1axd6H9LangU/FTPRNHFylf0iQeiPTS1x4JNeCpZXk+uDNcdGXax5QEM9pMEKCcnXrSBOh6ED8CXZ8/Sii6nwqM2xZ2ajeDN9/Q3aN4YsICJV+KISJ4PwhUwOdeUFDyWgkuWa2IceAK1g40mCYA2WXwM2RmUCkMrD+EsRPQgz9MDrVC1YAQWW4on/ftGPClVL8kjnBCpuge73bICQJToMHO9uVXzer6xYhd7tZB2OGSbcNuS5SoaAWemKHgXj/LGg1Hi4ppabqo9PkTQUsPqG5ipu5aNXl1uswZqUw0Yh/GXqzPHStN/dKeV1cPAaQ1OmLuWtbf+yXFZJXpyh4RKV7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 13:00:07 -0800 SJ Park wrote:

> Let users manually submit a report of a data attribute for a given
> address range of memory.  Let producer_state receive "submit" input for
> that.  For the input, generate the report based on user inputs that are
> written to the appropriate sysfs files and submit to DAMON using the
> core API, damon_submit_report().

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

