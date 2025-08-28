Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60402CA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA05F8E001A; Thu, 28 Aug 2025 03:35:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50F08E0001; Thu, 28 Aug 2025 03:35:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 940A68E001A; Thu, 28 Aug 2025 03:35:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CC798E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:35:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 455CE160A3F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:35:11 +0000 (UTC)
X-FDA: 83825355222.03.18213C2
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6C2A616000F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:35:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DLUpLUx8;
	spf=pass (imf08.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eP+OdhpAXeM3MeCoK1wrQ3GVDNoiOJzpSPwPKz/ThLg=;
	b=vYcg15LLEha05TcSoCL8IEYCSK/HqmDfBKK+dkTgZIKEfDdi5hM/BVV08DJzCn9pRWy6l7
	Nob9CZXNYpiTfQ9TxGvjwpcaWr4mu6QSUo4a+Qj6dhxePyefDqdSJCFmlhTb7OSunkYeMU
	4h72w6QKn+UcrP35xr86JRnGTRpNyhM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366509; a=rsa-sha256;
	cv=none;
	b=e+0u1T7julVpK1xzzU3q5hv6vUKe+0iD1ow9gA1LZtkyNwY6b3h1ZJWoJW2yTR6Ja4uHQ4
	3Y9Bjm+ja3EVZs4dnw/0NwJdfRGrhpNbM9NHS31Z+/AHtDPMQrxewqodfYO9XrwyGbKF9O
	knpW0TqM7aLxShB40M/Dn5lE7h8NdSE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DLUpLUx8;
	spf=pass (imf08.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7704f3c4708so785819b3a.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366508; x=1756971308; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eP+OdhpAXeM3MeCoK1wrQ3GVDNoiOJzpSPwPKz/ThLg=;
        b=DLUpLUx809pUa3gsCnEBp8Lp8vlt/9UF24uPpUbkQ0oAsYgnFhp7/wQGG7uu2BVjf+
         Q+PaAhnsEdXwtKgwYCadoqhB9votBnFlxtH3YLm9I+ojIZfmdzGvxhArcaBSoN3jRuqz
         zD6ycswskilTiS7k0kDwse3ipQcJOpGxSP4I3Mr1/Uu2J0ZQ4JwxkRkZyCnyP49fqgCY
         CVdr/UrnzxKBptKwriqiSE/Imp7aEPVhKOrAkDn/V/K5HYpDhhOqCK74mLC2UsLIk2TE
         zIaYcsFFhzHiQ+4A3QwGqeaXTj1gnwzu9NbEiKFG8nMd6HWPH0F+htTnUbgLUkkvXPdK
         eqFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366508; x=1756971308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eP+OdhpAXeM3MeCoK1wrQ3GVDNoiOJzpSPwPKz/ThLg=;
        b=Y2NCAwOi6ogsQjeTocthpq5dWIPcleNEja8KI/XoAf1F0OUrcluz1hEkCoTmYvrs3c
         dMzi+URnoAhIB8V+vX2xdvUXuu6MBu6XlD81hQCWMzR6QIqaWcdPP7F4TRfhz4Tixf1p
         d647t+KBqTNhW85zcfiuulE7Z9LcXHeuySdxCB0JfNnMq0bR4RcMpvSEqXR1lPhtGna1
         qgE4XZxz8TAA1dvIIVME2gl/127myWAJuyqvz9mg6yUhOxTd7EjGflLjrB/lhUPp7khX
         vg9kAUIutICGsqrc/hws4PYJWgQPbDwpLaHL6pLuYthj9CQUupcwQUbeDJ4+wXHO0hhJ
         YUKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhsmNKLFCVA7FNILEjJc2GWKQTqmsJb+ab6/oYtLZVUnD79Dv3bC7fxLYYQUtrAXAYl1R88JSlng==@kvack.org
X-Gm-Message-State: AOJu0YzSZK1onqOs2hal5IWHDasUcVU74CctgwKfOxacv52QsdRDaIIR
	ESvbyHNyyohZQqcLZx5Q4sYcA0gaHt45EwxNPcPwWuauOSwKG1AZHYbL
X-Gm-Gg: ASbGncuyjRR3lyIvluwYayWH80lmQM4+frDbTKw1vxq2NpkEAEDK0biztF6XSFPDwT2
	HhPWQIBK9DPXjHzbiSwu7F7i6jn8ZeYzvz0+YZZIwNsybDVOWKYNKPYE8DtqdGP8zoRJcMVIpYE
	9D9P8nyY3EKyQv4dUwnAHvb/Py3PHIy1L1ONYh9SaXGAx1CS0bN8P2Vqfl3ugvrKOz7/q6YbqKh
	ZUZhiieoGGtjoXu0PBlpy9JX2I+m+lxhUSQjZ90wHk/sNDHUOj77jNeLnxAdIc0pq1kNi+H2Dhk
	FyUZDnSD76XEQg+vNsd+MzgrJa75x2PnL+eJd+V0JDQa47d2FMUqWPXu9zPm8QUyxlZYWhmmnf6
	YrfrewvA2rH+ZcNGwMlPm1FQOL019+yGnTiE4MWI8l6D6Fx/ZAopmaFLXglxa
X-Google-Smtp-Source: AGHT+IG3E7HsLBsyZBtUPuuN6RttHjWI+4mOI8ICICciNWM3PhjKuCGhtkvM8/9T1iyfrPsEw+5ApQ==
X-Received: by 2002:a05:6a20:7291:b0:243:b144:adaa with SMTP id adf61e73a8af0-243b144b09emr1456023637.54.1756366508342;
        Thu, 28 Aug 2025 00:35:08 -0700 (PDT)
Received: from localhost.localdomain ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb8afb7bsm13182613a12.16.2025.08.28.00.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 00:35:07 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH 17/17] MAINTAINERS: add entry for KStackWatch (Kernel Stack Watch)
Date: Thu, 28 Aug 2025 15:32:50 +0800
Message-ID: <20250828073311.1116593-18-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250828073311.1116593-1-wangjinchao600@gmail.com>
References: <20250828073311.1116593-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6C2A616000F
X-Stat-Signature: kfskffm5yciqfhwfyrqiyhs1kxbrh5ai
X-Rspam-User: 
X-HE-Tag: 1756366509-78831
X-HE-Meta: U2FsdGVkX1/lBMSTWrnGghmPcnrgdGfbmmAzITtioWhNiiU6ZRQgTvPogizL0zgw5rhgXqd2RyBy+Pa1Rw4jqT2OGdnZm/0qZV7uVix4fYLKwQaY8Q5cHdpU7gfNEhHCT/+YHblTH1k1UIC76i65prTHUJzmlEV0hV3ENtQWFWiWg5CmsBLdysXy1ouo2mtj/zOlfjMC3+3TdAHLzDdKLiRAKJrTuElPBzCi6v7C+IGc0lyemWG+F5iNBGQfgDWEzqRjILXWc9N8nx8BEyJgn+KRHw/hXDEwAhy7CjBNbRlwijjYp9xAGGkIoB6h7NM3CaOK6LBrrqR9qEC7oPl/loaf5PceWAAzCmgI7G2P+s1kISk9RHONGCpCJ5rh0CZr85QqoigXHqD+FnMZ/0HHePB54H+kPVcSr65VeSfq8fwXkDUzB8yLtp1pr6ZpOKllJ7HQ138yIvh1VmsK/nkByCkcnzLxQ/ghxYwlyLKdwSgXa/07c5JfKnQDpj10VttgVqGIgAfwNNaoxAdNOeQQ0no5g6dE6wMOfXU37MEcYSByECNI+JJMGr9Xl8lmD/PIqPeCi8X9PD/pw4dc5uyVE6F1eZntrNXhwyESnmKHJQsyXS5RIagotYA3cJYEo8dkEGz9M7uz8Ps6s1bbb2VWtcqwSBkXPukYTcegpphhf4ayDi7MCvJ/uYV/lsRgUsYpghvutw9n9XbfWFtNE60Pt4DsJ3jcttJvBmsMIYIjxzG0D1mhEhW34xGEjj/vWd03+ZYUeY0mNUG81Rd2uP+r7DOzudkDK5xDsQSrAlfipmQ+sAcdGq1+7HRzDWK5YT/EO4eURE5WFrMoJq4YrHvghd3vF+tdRlav3aEP2RWQfFM8/t1+LFBDpN1POxGHcHP3PliQIQbUvGfkzOQTExpXkAnPtQ3DWgugNf3gUCymnPhZnKwne2Ezg7v5cuRzdVD9FCrYGu7ndid086mmYhw
 CLRQVcBU
 2PFSxYTJrgpXLhZkYKNTJO4moydC1UCTsVhN0uDe9FX4yciagnOUOcksW4d0BCwcUSNp3yXZNuBtRqigdsn74bKfvoFkj4eOZHNUkCr7QMkIJwE0ZWlXWTeCw/nrEEVffkxBKV0IwcleDGXc02bH7a2RMdXshSE1f+2u7eYSQHxOr84r+OyzcfwcPbPjdTkSqj/gOq4eYpVb56M+9k6zdK2J/guQbIGV6lzSRR5q31UOgJSIC7f+NjRgdkV5o2ZBPF6gdrKZF7OcNCtgZH0/Jt4rn5xUNIHxKreL1jo81PtL2rNZh0BuNnZHBgkjRukN6rTg4y2DAVv85iWpfpmZ0XkjMUtCTTI35IYHS4jaK5DuhTjYevNAEHT5x5HHtoWVt6pQgCrPP4rLnx1e0XmZt3OVAxOICWv8vr8uQuWlrW9rb6CfwBDb7EwMoO4Wdv1uTaWf5QBYdRDokcvKNA++Xi1btxcN4tBrvTBLN0UYButMPo5PaRLIzSLGgxvfwR3NaULZi6ypXtUNTQ18=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add Jinchao Wang as the maintainer for KStackWatch, including its kernel
module and test script.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fed6cd812d79..097a0462e604 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13354,6 +13354,12 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git
 F:	Documentation/dev-tools/kselftest*
 F:	tools/testing/selftests/
 
+KERNEL STACK WATCH
+M:	Jinchao Wang <wangjinchao600@gmail.com>
+S:	Maintained
+F:	mm/kstackwatch/
+F:	tools/kstackwatch/
+
 KERNEL SMB3 SERVER (KSMBD)
 M:	Namjae Jeon <linkinjeon@kernel.org>
 M:	Namjae Jeon <linkinjeon@samba.org>
-- 
2.43.0


