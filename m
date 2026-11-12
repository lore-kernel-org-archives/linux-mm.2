Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B78D5606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 00:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=perfloop.ai header.i=@perfloop.ai header.a=rsa-sha256 header.s=google header.b=RoNda6i+
Received: by kanga.kvack.org (Postfix)
	id AF34B6B00EF; Wed, 11 Nov 2026 19:56:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7D306B05B0; Wed, 11 Nov 2026 19:56:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91EB46B05B1; Wed, 11 Nov 2026 19:56:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CD296B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:56:01 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB5441C286D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:56:00 +0000 (UTC)
X-FDA: 85424650080.20.443CD5E
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id C44F2180004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:55:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=perfloop.ai header.s=google header.b=RoNda6i+;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=quarantine) header.from=perfloop.ai;
	spf=pass (imf06.hostedemail.com: domain of ts@perfloop.ai designates 209.85.167.174 as permitted sender) smtp.mailfrom=ts@perfloop.ai
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794444959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGlo5KpYncJxMag4TeoNCPiBlXpzDdXv/wZ8+6Y+c9w=;
	b=4p5aHk5aP7Sv9j4gNQesj0TsFviOu/Gg0r2h8Lcf8E90U4dxMwBQ5foYQo4itBufvbrmrE
	N+YP7lVz/Rl3MUTurkTcj//72BRv5Qo0kvTjM5t4LZTebpUnqMg3LeFKMeyqnOivtPAwa5
	gVqBeok/UairUI8wD9WlIX/R0+9lTns=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794444959;
	b=4JObhUZ6dIWmh8NVEg9seOkvTC2KpLu/k5EXLdMrCOgA+LBdIvjP7Vt6SeBFyGH4Ytgw9D
	9mmEv3NODbcpW6OomGlNkvf+PtnyDAtVniV0Qn71OuVDdcO8nXIQ+jepWWLuwHkw3AU6iW
	2ZEwtXBvYh8g1qerjULAjqG4iqzKeXM=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=perfloop.ai header.s=google header.b=RoNda6i+;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=quarantine) header.from=perfloop.ai;
	spf=pass (imf06.hostedemail.com: domain of ts@perfloop.ai designates 209.85.167.174 as permitted sender) smtp.mailfrom=ts@perfloop.ai
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-53c156ba662so1925114b6e.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:55:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794444958; cv=none;
        d=google.com; s=arc-20260327;
        b=EZohRfh1YjqFrIW7P4LUUqlYLCMhOuX6jnAUijJO+fk4UDNDklSFlbBIvlEVPCK2Gg
         CEbuq5zhsbivvx0ziEIm4FnkH9IeIFu74Lhxc5XMZ6J0unStp3kuJL6W2JiARknKvj4J
         +cc90ab0H3qPb5vg7f+i2DWLjJ9mbb5ujzW2Ml+/CWIyCVouFMGwVGtEUNGXLoAF20ij
         SvTcIvEhLZxIv1kx6XuigKv1XwnNKKlzreeYqnN9iZU00Pr3TPn5n8XryXwO8Js66R69
         DK++rsri6sjfhy4M5xViwBJP7qtn6Ck3QDogrk90ZGjB5fgTiH2C1lH07NbBZgeVe4dh
         OMuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=bGlo5KpYncJxMag4TeoNCPiBlXpzDdXv/wZ8+6Y+c9w=;
        fh=UV9mG69UvDialvglRFoBWIHT3d+w9RJj9JiRjjS45uo=;
        b=MmS/m8PeIdz4sZSDGcIbQSFRJhErElW91WRM+OjrqKNmPxFL/Qbb31TV9voMCb1kAK
         fwC6TskFF4x6U13SRWGUMhEETbo4pL108eIDG5J7Ypow0fZFa1D7d4c6HN1U1h95Zfrj
         weRxmQ16WdJDP5oziQx2VkGOqrDeHgHHxi9r/ngsm+Z9UaQThDtwZyBs2vM4llhq0ARH
         5FWMEJWo/V7ouQWmDtUv83FRDdvqG5Pa9ZADS2bYx7av0IuQulNQvCUFhJZbyxre9JR+
         1KPULZxYRY7vKUkxrlrIM99q7nAOqMZ8xeXVRjrlDlimNJo1YIPmkk0BrwYZV8xlVqqg
         5zew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=perfloop.ai; s=google; t=1794444958; x=1795049758; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bGlo5KpYncJxMag4TeoNCPiBlXpzDdXv/wZ8+6Y+c9w=;
        b=RoNda6i+B4Dd8cMsV+qD7zKERcWrmyoWOhoxxO87pJPUA5MT5+/kjCSIxe6I/Vh0Zo
         1xcs3t3Xi+ncSOhAqOI8oW3LCMGss7JYLcL7zFo96Euvw8eA8+Xt+JHd1TVWbcGu6iXa
         EooLR43jzythtDWxK6nhpmJ1DCnvKlzqVNTRQuhgpz2u8056UM9e9Q+M1jzlIgPOsPC3
         28xiKMgo758gQvx+n4i5Sn3ihqTnlNTZ9Jz1PilH5Iqei3ZE8+sbA88a4Nf694F5dgAL
         I2e0JuyZOhb1J3yQS59ozui0QNHHQhEzl4uyYw30Ot0p9Kvb3hcNUobE1goXzuBBLUDV
         OSow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794444958; x=1795049758;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bGlo5KpYncJxMag4TeoNCPiBlXpzDdXv/wZ8+6Y+c9w=;
        b=yIbn7eXmZQ2/6uGc10WlhEHKiIU9qh8TtzpR8sqFjk1glRhrd6jt9HAed62TV1PYwQ
         q+9Fu2uYzuYnNd1YTmJPbgd/cSrxsKPdSIvA57tQCWjmpPOCXt2BBBk/e8JPLPUGvcDU
         7PO1l1033oXXVZOx3FwON2FyZuZMQBL9lx77VQkMRWukAJXXdX6SdI3OWV5pqcdQ492/
         mdHoLjgIHoqbDtBafWDGg1KT5p0wReMmn8sXTRIVFcfSpS5xAKZ/5Zzq5foBZze71Tup
         WZzoJLVT7z8nFXdetyLxBImlntCJoa+G9zhFsRLikp1JDIlQ3gBUQ6GIx04gN/AA16UJ
         s1aA==
X-Forwarded-Encrypted: i=1; AL+hErGg57GXKKXTTl/jIzh2KJkboKHZ743r9XvA/kOfOv/T79cyKpWILDmGlkERmEd1JvPUBDv16elUBQ==@kvack.org
X-Gm-Message-State: APuU4Z9wt8/+VNPay2DN0oTnqHZE+jQIaUlxxyFeAtsUF42MK++FhpSi
	pXZN/W+lILkgZ7C6Apfhv4ZYa2V3m3Jjan6Des0HWznN2rtTw4JuW3u1FbWITkwk07o2RVhGW9T
	D1fOYRjb6ihQt4hqKsWlaI92pa8LFDAeZiewIEjAmBJI=
X-Gm-Gg: AYBFou23qdnI2NWvaZp8mf/K6Icq3ejeHaXPibeXbFvR1IN5IbvyE82HmdfLTCA5eXi
	ABx73S1BB0uN/XT5sX/7EtR6dW8ZZUPs6DiwHO60KUmwPH6ky/1DcLNzKmuQHBeKbxZ0hybItWB
	gKtiUvIoSFMDWn6U+cbKI0XMX/Q3x14J0eokivZd9ai3qTkmul8oUyVPfzEBhM6ON5rLJcx44yM
	lsoDGf43Akj9HIkDTxG9mL6IK6MjrwGXmVft8mnJuDWB+oyLNYGhBTXaXGzz3xCwrWMCyIDYW2g
	ADMkFS1H2zYnoRJsutrHw6+uu4jzE+iIfVrx+TBl1CS4RP/JiQYTAsDBJkCzM3awGZSTKWh4+0B
	Cfk8LWvQziRGfqBup7te0Bp6vhe7ok5bKF2vCvUNQ3WA9LkEDHVJPWOf99Fa1JDivq1lk9+ExEh
	cYpu48gS3GLWRWCyrIweWBCZZwm23XyzB1afCEDIUuCQstx/ZC4ZilYa1HEiZh7NNoMZyjtnZyM
	JuFJxejmm2ZmqZDNJ2fivSEtPGKq/y2rVovHShY968swWWLQ/LVdZCUO60+qDnD2GJ7kyEWyT5m
	Xp3IwNPfMewGFlqE6sU=
X-Received: by 2002:a05:6808:1a02:b0:564:22ae:a68c with SMTP id
 5614622812f47-56b968c7f46mr3958629b6e.13.1794444957543; Wed, 11 Nov 2026
 16:55:57 -0800 (PST)
Received: from 202080787392 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 11 Nov 2026 16:55:56 -0800
From: =?UTF-8?Q?Tom=C3=A1s_Senart?= <ts@perfloop.ai>
In-Reply-To: <CAO9r8zP1o+L-akRDJx80bgGj8bf9rdN09t5upPfkduSmNKwpKQ@mail.gmail.com>
References: <20261112-zswap-zero-limit-v1-1-19f33081b09e@perfloop.ai> <CAO9r8zP1o+L-akRDJx80bgGj8bf9rdN09t5upPfkduSmNKwpKQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 11 Nov 2026 16:55:56 -0800
X-Gm-Features: AclHuK8o7gpgV7y1WpVmcJ6YTUQp2s3lnYXN5gQ-xE1Y6TctG_9wPrkhGrG_MY4
Message-ID: <CAEEBa3VA2vycMaRCe4K-qnO3SGCuvAqhECmjmk6PQC3xxERiLw@mail.gmail.com>
Subject: Re: [PATCH] mm: zswap: honor zero cgroup limits after successful reclaim
To: yosry@kernel.org
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, nphamcs@gmail.com, 
	roman.gushchin@linux.dev, tj@kernel.org, chengming.zhou@linux.dev, 
	mkoutny@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@kernel.org, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	cerasuolodomenico@gmail.com, linux-kselftest@vger.kernel.org, 
	shuah@kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: shcf8suo4pzdgapg4xd7umedf9hffbeb
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C44F2180004
X-HE-Tag: 1794444958-572050
X-HE-Meta: U2FsdGVkX19ydwBaMau+qPeiwCdAklLKe+e+S8txx6nJNX93CtEvgsFmPb1EYrrwFhGArZYFDk+oDug0wPPDLYch4XJesAxoyvK+wq01x/JaD5I/E8h8TITGclDaS2KgVbgz7Tp7EbeIe5Vs4NnDT2dVvyDxX5GhGv0B4CkRKYnGq6PzyNMmzOJEMyKVhj58UW0vDrfgneiNvxYU4FT0EA+ntIKrQu0HbUlPnOYeSO+3KbkLsPCi4Xac4i38AVtepww3zYt1XN6Jn0+0jqS8BA6tntSNVfDWYwxMgJLPf7Bxzi+DvjdToz85KdI++mzjO6poKO9mQOqgaGPzRQVnACQCrhegNkfLN7RLB0wcNoWQCRALun1l2ZYxUxInvwGJhjs4QhQ0cFiuY2DrWtF10DUgSh5w5BG+grtCZZL90XfW0PI2Zym7Ml3XfvrSlz2u3CpNrnrj2lMv0bnVG1WoAYv+B4uodWaLlohG7B8gPbOhOm8dvZd6WxCTmmLKtGaIE7aoezLYYxThw+IU8zDzfdT23/k7nmdoimj4VIrzB6sDbCj1+qn9+MS4BVl9gAH6w8CYamzjrlLIqNy0AYmYDhBUR/bCmzvD03TnnpHtyevx2d0pPyDxy8IVXhrqG9UnQ+uiaT5sVI+b6MiOOoSc1jZdZJqtrxyzTewQ4TC8FgjR3ikz5h3VoFE31jJDHnKzINLqFCFXZ2Fhvd/5QckQoF94so/yD9/5bACm/inKznlNo0WYY+UF+rWT5WzGlK8H3olivsT4ExBWswxm+EJyN4coRafHgMVLt1DBtIDMI9y8q3mJzbXH6u123Ap0s2/vwDH/1kEIDKlWrEHEfYogA98oZo+e7h3QzWw3+M5vOKyJ/rnEvx1ofJTKVB6c1auNqNmEBQMnrkVRKpFV7ZJ19aKWWm8i5e8IQq7w6/wQ7cIYcBL38QT/mhbtOp8d6ZJQuJ+nojzooMYehmcNFVS
 v12qIGmi
 QNHUUGU5wop5V9wthvGmiGQ677jdjZyAUiMnL4QNaHnsiZci2jgsxW1vj/e5eA9jwTaeLbOv35w2Q9gzsOiDHJAykxcx9xCz5yhU/bG89GW3COBE7vXLaXRA8kE8N6UzzvDszrgu2+Ebol+/pk207dqqdxg8AiknuqNhO91jylpdljtN3661BNP9YhH9dZawLgUNieDUJXvYg7le4HKGV7AoEPvEE/uL5aoCKTquG1t4Vie111eACJluCd06kRg1Fr251dlnousxW+FWAnRv+iBGwZPLKtZjTDaN5GrsTGqCZiPCLmsYezTX+3iZ7ZgwPQzjdMAlEgDYcHIZ70xBNv5Nap0Bjhx3k7L34WiTMiEkuHrta/aqCw2rQuAr9zWfMkuWvJy2yf//5XHc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 12:28 AM Yosry Ahmed <yosry@kernel.org> wrote:
> Why is that a problem? Setting memory.zswap.max to 0 while the cgroup
> has active swapping processes is naturally racy. The limit can be set
> to 0 right after we check it again anyway?

Agreed on the race, this doesn't try to fix it.

The case here is different: with the limit already at 0, every store
writes back an old entry and then stores the new page anyway, until
the pool drains. It's bounded, so if it's not worth a special case,
happy to drop it.

Tom=C3=A1s

