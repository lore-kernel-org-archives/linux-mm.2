Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50E51CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 16:46:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14CBE6B0088; Fri, 16 Oct 2026 12:46:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FE496B0095; Fri, 16 Oct 2026 12:46:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2F156B0096; Fri, 16 Oct 2026 12:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D3CE86B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:46:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 65D96C04B0
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 16:46:01 +0000 (UTC)
X-FDA: 85329066522.15.CB123CB
Received: from mail-pz2-f8.google.com (mail-pz2-f8.google.com [74.125.228.8])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7BFDA100002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 16:45:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jrnc1BA2;
	spf=pass (imf05.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.228.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792169159;
	b=0P5xiVzFD5wVAi9V9hhFfw5FYu0U4TQYkJDgMeou5fk4FWOumLGc1UKvjSKtl3Op1G5wNH
	onXVEPZNCPwc1lvS8N+cQE+hOYuFCP1R+mtcm2J/SDl8FLYDTjjT7va6IPrHx9kum1DRh1
	wiIV27Q8SWrbYYsIAfSBYHr+g9MiIY4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jrnc1BA2;
	spf=pass (imf05.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.228.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792169159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yWna3LGyk7AO4Z3H58l7fcPnAfl+aPw+asBmvCYoCyI=;
	b=GZpcNTS62mil5xXp8J4G0JncXD3pvNpmGAwVQurKZ6P6JnmJwyMQpHDqYyz6cpfjU0BcjF
	XwXTD7nFhOo1bzXivzGrUUJ/9iqjP4BNMh505o3A2lzIDwYesyIKH/APl5Kh5Dx8LrHUO3
	INhepN/CZk14hRDU39J8h1Su+JleqEM=
Received: by mail-pz2-f8.google.com with SMTP id 41be03b00d2f7-cd5cd8e8104so38799a12.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792169158; x=1792773958; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yWna3LGyk7AO4Z3H58l7fcPnAfl+aPw+asBmvCYoCyI=;
        b=jrnc1BA2OMfTm7Bpze3LJox7YTBoKeSHOc2ezBlQdsuPaZwbNqVS+eOgJ7u8eqTQxd
         fSPr1TYe52bycyfXyBuz/8x+gFLNPELwD15kLw/O6hcFHSMFWOFZ99YG4lFA1Zkj2Gzp
         kNsIv24Tm2Z31gH1ZF84CJFsz4S8wqOgO0CoAMDANMht1L+myxNABRBafqLnA0EUTgCv
         fW5rVZGPie/UDYoxH7WDZrzPgeaS8J+cHam18AxIWLbKUVfnOecIWiNX6PSW+Rf8M7vW
         0kFCYk8yd7l6qDccCL0TsjF61b9HpCfHTQZZB27Kc+X5xOG61xMwx7EvVw33ysNIcKSH
         uaBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792169158; x=1792773958;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yWna3LGyk7AO4Z3H58l7fcPnAfl+aPw+asBmvCYoCyI=;
        b=WSiUgBBYBTLjYayIKJZ2D65z/y6Ytn0zDsgtpK0TS2ISD/2nFtqIueUx6GGCVlzqTw
         /oGi40PKMwf6gHoRjq1zWnMuqcOmjN6s1ou42S+drM77bWLh2lVQ3efsLCegWSb1RywP
         4CmrMKVegcZ76sLJbKScKzcPTXgmfSYtUMYHJQKQi2vV59R+IN9qYjJELv0p6DtKd5PC
         Zkji7l74k1sqTnWGW5ZiyKe560Pvqy3qKYz3F4C4g56K2QSwqOzmAO92jJ3McF9vz4gb
         SENl6E3eJLHikOjbSGeN7gqX+H8NMA3OH0wwnmQ6butscu2ODjzKmY4nJjN5mkr9GmJM
         swzQ==
X-Forwarded-Encrypted: i=1; AKwUvByt9G/1Ecwgp0k7J+woZxZCoGBBgnTU6lpDbKeQcJ3LYYvE5xFhnnZ1bNd+dvHfvgdtEcFQ1Xoa4A==@kvack.org
X-Gm-Message-State: AFq9FYKY+rWST8E3lP+fHei6iz8oWMXKuS9LhwOeZDlVI7Wr3vo9XMzB
	IlJT6673mBwYIVYUtkkRGhpgrFrBz4yALWCDlaPUl/B0Bzuqsl1Kp4y/
X-Gm-Gg: AYBFou1Pq+NHPj83F4g/lPO8pVDN5gUhA6VM0E7sUsfXD3SJKWW+6Nvz3ug4eVtxtF2
	YnN9KhsHGNjpdpJKodW51OEEXlxPNwgOgzQkEATlk+sRwMYKrTIvhFYWg41FD2GrOBohJdaSBG/
	Ldz+ACkj04UMpwLx5u2IUJsMVxvL6qvoARGiivCPOOkxPLVQJeGZwr05JCwfYrgawrhNL05ttTs
	mb2JocLv4aA8K0vZ1XeFxzlvm0r8l7RD2wtlSrmTZwOQ5Pj017Fqk4Je2sUWCU+OKMZ5I4vAc1z
	iX/hPRBqp+lsA3BKFZLVrv+Ts/jcoqFLI4moH+XWktoPn3oF1e0pGIFXqcfHbe0mjzSf9zYhUxF
	DuxVx4ffZhUWcOn6zoIFPDct2Yx0bXfWSzqOwYuvoWj6MQm+QoIJri57YhWfWvGrMDvAw6T+k4x
	G184S0dlWmcfhWXPWuft5pu94Dg3Vze0U/pT511vdeh/nfGRA3r/LPtI45EqchShdd3gcT70o0H
	Ws/2IsuRTfQ464D+7d8gBlZ6SZql7M1CnTNjA2aahXtTvDfJti3FctJFbhx29DKCX5umKRFlls6
	zgk=
X-Received: by 2002:a05:6a00:2355:b0:89e:3742:3e16 with SMTP id d2e1a72fcca58-8a04ba36f4amr135378b3a.18.1792169157872;
        Fri, 16 Oct 2026 09:45:57 -0700 (PDT)
Received: from [192.168.50.20] (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a010b39a37sm648600b3a.4.2026.10.16.09.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 09:45:57 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/damon/reclaim: improve grammar and style
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Aveline Noir <jm5905938@gmail.com>, 
 Manuel Ebner <manuelebnerli@mailbox.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, damon@lists.linux.dev, 
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261016142921.126622-1-sj@kernel.org>
References: <20261016142921.126622-1-sj@kernel.org>
Date: Sat, 17 Oct 2026 00:45:43 +0800
Message-Id: <179216914308.58773.4774391289742300524.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1792169146; l=369;
 i=jm5905938@gmail.com; h=from:subject:message-id;
 bh=yWna3LGyk7AO4Z3H58l7fcPnAfl+aPw+asBmvCYoCyI=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgboJ0y2WZIrQV0H4HJI1WEQ5sxS6pM
 Nc/XEYGLW8ee6wAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QLauXbEbo1Z6pn5MzDJimI+ZcqaQ2pweWmRLgCUWN9HvAatbqa+C2vTY/zHaGewbHARInlDH+zY
 6fx0IcRSlJws=
X-Developer-Key: i=jm5905938@gmail.com; a=openssh;
 fpr=SHA256:oSxqik6Pl1M8EjQW1QXKHoylm1jy0sguOWFFJlA9zf0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7BFDA100002
X-Rspam-User: 
X-Stat-Signature: 5etr7qdspfqz48yi74mp7gwbx8mywa7r
X-HE-Tag: 1792169159-157557
X-HE-Meta: U2FsdGVkX1/acQpRSJaifUBP0+5kDbaGBudRaB1cF17/DknSuQ/FDQty6P3BjvvnRFDFZGnHGLlothYc+5Mu2R2C0bHvWgP5wvegOLp+qd21urXS7OZupf16g2HxAdTkui9jS+Yq8bJwO2QSR52zOammWLgr8XnU1coVW482d507Fkg7cCZWsFTQFuucIz0M6zfE9XvC3cQZ7zq4Rbpri3iM28jrqvK8FUVFvcKnTw8EYzVUC90pQDCHyXJBAkePwS4z0E7KQRCpxnsUiu4G6bUhifrNAelN6+qrtGVahMd0QDTfz3qM432COJxnNb9h2arC6bnMRD0RF0FJfeII6F5ZopmM5l57pFJV+Dp5eMxmUtAiFk5/Q0cP+J0+RRgIr4tT/5W6ESw7aVUJpl5PA+VpKH4nI5Nj+IoWDz43i6W8ogYYjwqy9uggaRR09hmhwAKDsuHTlqWqhkJZ1Fzi8zaDYHg9+la+j9ZXxGQlurcT8EKk5siCQuB2W2Qv3g4BJbRmJcdrHLqP/JPIr/dDvaewCFoR5YfTC4WQDrRrYy469of8tIbRhOGiyNVnVhziPEB9QnkdnL8/3e/+Dm226468GywatqbYQlWAHrptnICiN01QOaXMgdh9lOlyI6z/JEgaxz1ITuqlJFfJ/FMd7fqxuL5lmn9pv4zhweSzxH5oIPpW7jdVqbY12VguCJ3JrlBZc/e/S56z5Px1pJBWzAziIkFwZdAqpIUc2dT7Z6QdnfU02CM5kmF05YTlP6rPjUUjFbjOl6oYPriUI4iK3hYiXbyEexM9PAbpEhDFjWl/ONkSNMyxNKr2m1cIG4p1wPJBQrLPSo0peARnWCRqi5KDl13ABxjI9XMiD//L5Khvs0e9JuAeNvYKARJ5uKEw3DtVXvf6JAytkWJxf26NCz7Y8ZFQ9hYrLUTCgXay6IrlEv6/YDLEkGk/uPHxwH81NT4fvIziKa1bmASZ4PJ
 /Bx2eU/w
 TPe+bI5gFfP6uGoMJsXG8cUkGY1mW20QVqv2RejJteZ4kLalqHweAJWAEk2PedcSSFuLaE8euDIjwb4KvA32xygQzwlht5soTe8wYL3ova8g7cZMRuTGy9rb/LcLS/K7ACFsiDC6pPag1iWk0SW53asP1z0NZZl83PS35xGXtwbDrRe/t2us66ewkioWAbTBgReiZUvxMjeIYQBg3VLbBkdL0u76vJnF5MyWO/KWb2J+bqNl+ybxXgl94wWzC3e07CPj0x5I4/S1Uz4Xsxc5sQyYTrzrI+LuF9hQyQwruGQXiPFTlIeScby5uA+A1IgUPLcdJ8QmSsrAGP3aSQRkBFinYXQhZsp+Hx/aekFwTCX5luDUQ4gZ2nXU+hIdGVMJsX2rkcrISsKeID8ZKe5ElZS0Hsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On Fri, 16 Oct 2026 07:29:21 -0700, SJ Park wrote:

> If both of you agree to my abovely suggested/agreed changes ('s/page out/ pages
> out those/' and 's/records/charges/'), I will update this patch in damon/next
> tree with those changes.

Both changes sound good to me. Keeping this patch focused makes sense.

Thx for taking a look :)

Aveline


