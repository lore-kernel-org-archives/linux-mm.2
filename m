Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FBAEC55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 03:23:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A67106B00A3; Wed,  5 Aug 2026 23:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17F96B00A5; Wed,  5 Aug 2026 23:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 957736B00A6; Wed,  5 Aug 2026 23:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 388546B00A3
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:23:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 46C90C0640
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:23:03 +0000 (UTC)
X-FDA: 85069398246.25.060038A
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 77747140002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:23:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=UhCM+2V3;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785986581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LK229z3Oli/D7ny26DNtak6xHVe6My0e7uPt/sOAXlA=;
	b=QVqqwr451y1pfCIcB6Uo+mgjp0KZBeNik4CHC0/iioihiRhZ5g9+WWnKRc/3ouixx3ymLH
	kGKdlhclJVcBTtrU7HeOs2rO1VBmeDYQ7drxjJXbXWgvtiDG+WpuvmBKHmMIU3RVtmJE3C
	W+s3s3313ZwUFnAufNZ6LzRCIqvoQtQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=UhCM+2V3;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785986581;
	b=ujEmF6TX+O5ZL2LQl+jj96B75n6NIS7d5Z/X4vKJFc8RrBm379+UdeyqKVQ/DfJuOZFduy
	SnBb4uJbEwJMpq0lnlh11k2Yn4DTXeELu2KA1CgERF3Vl9/6GuAS6qxct0eM3SSm8JoILb
	a3pskUpXtwqL5AnypwCT/CBEm29r9aE=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-848761b5897so1299816b3a.3
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 20:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1785986580; x=1786591380; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LK229z3Oli/D7ny26DNtak6xHVe6My0e7uPt/sOAXlA=;
        b=UhCM+2V3WRoy2SmrTvnmECi3TycWURReTyIqayDyrbWPfb/jJqHv/Fcs8t7B6Jwuzp
         pnckmf4JT0yTlpK50pCVcqJl2b4W6c1ODigzwBp4AzhmNGFFE9eoui+dmORD0XcX44/i
         TDEQcEvLSVrivSz4Sc/8XsXez01klw9GmKqVM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785986580; x=1786591380;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LK229z3Oli/D7ny26DNtak6xHVe6My0e7uPt/sOAXlA=;
        b=cLLD75Y1d88zkzXtqQ3bwCW0slVsK1RBXODHzVloTRW0y0vx3pXuYKh8JATu64y/Os
         7jQNBQ9bCmftVVPjZec8NsJJ2VKCfj7ikf3tDUbz+Jw56tiCbN8PPBgL81susszK0+DE
         gQuSiVxlHgVM5NLmP4QzqahFlJZ40Nc7sozKLl7P4DueVgfvulLieNgQf7oAusi5ZHX1
         qvnF+1ivCn2y2Z/sCr7CgD8sXw6G2bDlr/LX/veKceAmrkFD9ZwZFlBrx+YuWGMshO60
         2BHqrlVtkKnR8s2mWTbM8M1kn/01KaUrWPbh75RDMwMbmqRvXgR3lalBJvnRzu13+lVp
         1ZkA==
X-Forwarded-Encrypted: i=1; AHgh+Rre2JekAZL3BEQK17afZGoVNCpVnECknI+PIkx1sn/q7g08dFFZP/dxWhhsy4Iq9BpF92YNzoBbIw==@kvack.org
X-Gm-Message-State: AOJu0YxFpopLdV+AQ8ZX8DTb2gcfS3X0g4uaqm4G9maKtpslpqEhvUKu
	E7B/bdPQ6PUaFdZmXZ24jvq+lMKYGjk+lYcBobxHVhDyj4/Mz2Ag9h8l0Xp7CNOulQ==
X-Gm-Gg: AR+sD13+jljLtEkqyBL/Wp36TOwaKR+wXgLVsmM5SmUDKafovxqdIEoifRpopCvVtiU
	NoONJg1/z6qKxV5CRKAnFiEKNO5VZ8sQ4XY7Sxpy52fiVG8+rs/fk3AVmNXEIhZt6+VcD4oViJ3
	oPl+Bmg8HcTlxWaaNgm7eCuqw9OM5rGiCiDHrQ0ThWy4pG78vTqlQux69hl+izwdwNt8TD0+8Ab
	3OA51r5p5PNeWWsBaZVGOU1ykqQwpLb0uehWkjT8cVJOIxzsyHE5TzlRnxqdmOgFe8cWDnmCLkq
	/kVvh7RfgqNhMo3EJK6JuK61G+NgInRO9orlcYSBuPsgIcTAQbqeM0vhpnzIvSaxS6FsQK0EtO7
	/FtuWpGrN3duOYh+KfZ+kvWPtR9du9KjaVKmuWpfOhSTBpxCxs4/NZ2JzbPzpFlW9/mM4VP3ZEs
	L2puDPenXhIC1qgBaFwkLOWRcC8qk8hrXitBIzA9e4yviomsz4H7vAs9XrBlf9JmS0x+ZpQptwZ
	zlxKrKhlGIN/2VmgVHkoWbxFDde
X-Received: by 2002:a05:6a00:2e19:b0:845:4928:8655 with SMTP id d2e1a72fcca58-84f2e0edaddmr10872408b3a.39.1785986580270;
        Wed, 05 Aug 2026 20:23:00 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:8002:2a47:a704:5a58])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f4538bb3bsm397524b3a.12.2026.08.05.20.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 20:22:59 -0700 (PDT)
Date: Thu, 6 Aug 2026 12:22:55 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Longlong Xia <xialonglong2025@163.com>, Minchan Kim <minchan@kernel.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] zram: switch to unsigned long indexing
Message-ID: <anP9rQB1EgHkLC4J@google.com>
References: <20260806031640.536615-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806031640.536615-1-senozhatsky@chromium.org>
X-Stat-Signature: 8e3zj1pqjo58dn3pakstmzkzqd1gxteb
X-Rspamd-Queue-Id: 77747140002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785986581-564012
X-HE-Meta: U2FsdGVkX19HziJqBjO2RD9WTB9IrjZIES6HbP/Ukkj7pcUngKoMygOtpdJhUeweS6JnrhMG3ykuZFiqFErYe0wQlLnk0hzFT+huC418lT4VDEqjxy1GYhpbr3ZJUvNFVvZCSIziX1Qsgir4drwkvR/kr5sJ48NXLQ7xaFQACqkKBo9A1gpQS3KmsBQymetPzsBC46Rh/OjhnYIZp87U6ThWxkGXvAoSeJIrtXrcWSp+Tldf8+d+oFgMs+ahLoT4m6zej+CswOw7GYo7iZFMhSyYzhcxx/YsuJfNMpe3YFmnBfdzJnTfwXQd/qv7Lqj/+XTIG5KqKWkhIziT54kphT8oEzWHi1X5HYWPEv+oQHxOl8+Fhy8zUQwlD/jBtekY60P2ui6Na7bPyvk8EaXD1LxDGqDBorrBmELJDBba/NcqxgX9F9GDMBj36QYrQfZ09rbJ+/l9ytVb6C1euwlsRC5z2/E3pCQJIRpnauy5WmWFgKztrU4j0D2eGI5CmBk5bSIDWlcsvWTqhOh/nY9+ztc9/3k+1KCIRSyK7yms/Crvf0+HwYt3d7Pdojw10/91C8gSfEM2XxMD3xaVAHsrptSnd4Iz1+I/a/+LdO7ALjw+RLjTb2TG9b0+KOsq1SIaLubiR5lRb1NLhkIhEZ5ApuHEn8RlggiuFwG8Zy0HX0wTmHteO2fvKjbsoDwDBCZja9TtwnLbmk9T7q7z1B7cQRhIs5Gdk5OfMeEHBz8Iv+k9PTVaK84R9ErnW99u0b7ueV796v5BEIiX8Gge3Gb99PjL2QHrjUSFOx4WzR4RaH4aIw7e7Qzh2pSUNQ2Q1kmydbjgBKRIBqV3mixzyihFpYVrbRAWJ4E/TTy2w1Gyb2sDrxE/d8ClAKNiPDrfOlE6q+URwpHGrkiI1V6Alolf9gzS6kSOA0JHZhvgiXgTG5heMhTxU//OcHN8q5NbOiOaNKgrwVIlm2b4zg5zfBe
 KhIe6qd4
 G3Qg9V0daMn7CXq5ASYtqvs5QfuwVyLsWvZHsk2bMag+mBJO2m64BSERZrVW9Z8E/VbMvQiUy824u264ikB8FTLlV4gzpuHXRAOGZbbNCjTB3igz4LruNuVv0n7Aa43AWWEOKFGdqZZGW8fxnOtvvNRcmRp1Ruk26ahgSClcnRN5XUS7CY57zAbzq9D8b5gWOvh7dLm+BahQHSaiP+34d3Th+G4/PFXg+8XJ/PxEUdM0S4N63pKtTDamkCsuyk6dKWXgi+AWDVqXSbMt2D+o00xe+AwBowCKKSYbfIOV3nn5pN6+QLXs113pCFv0Jcmh/nUwg+sgY8yC9nunZGrWbHKnibOIAcQ2j3KAqvfSMtwhE7O/cyKNK2xBE7HCTjI10M0viHhkWMLZiSefGejltHHzUniLEdhpDFBKL7FHZuS5u1rt6KDc7f+aDUUXk61EugGzsgqz64DJlB3o9Sm6xMJcszhJkHZBd8cda7vqdjywb4IPVF0f/5OsjiSP7YXjGmYfU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/08/06 12:16), Sergey Senozhatsky wrote:
> Date: Thu,  6 Aug 2026 12:16:32 +0900
> From: Sergey Senozhatsky <senozhatsky@chromium.org>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: Longlong Xia <xialonglong2025@163.com>,  Minchan Kim
>  <minchan@kernel.org>, linux-block@vger.kernel.org,
>  linux-kernel@vger.kernel.org,  linux-mm@vger.kernel.org

Ugh, linux-mm@vger.kernel.org is not a thing...  apparently it's
linux-mm@kvack.org.

