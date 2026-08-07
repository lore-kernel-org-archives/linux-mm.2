Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4224C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 16:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF0036B009B; Fri,  7 Aug 2026 12:18:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC6EE6B00A0; Fri,  7 Aug 2026 12:18:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A04A36B00A1; Fri,  7 Aug 2026 12:18:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FF756B009B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 12:18:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1AE271A045B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:18:55 +0000 (UTC)
X-FDA: 85074982230.26.3D435BB
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4D0D640007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:18:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LnPjT0vY;
	spf=pass (imf12.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786119533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xPAASAJMLr9J3CqKbh9dNVdhMzyGvdXIIGCu3+XVZNA=;
	b=DtXczpNbHxdhZoGLxj/OwzBJLoqYwWn4ETmjLwTXpe7GJIHuK1tC6skasjEeJuW2puHrZ2
	DSWA5GwMUv8vKF4+uhvX8Gg/yCWlpV9mPFk4tMuhWO1pysHlmk8fPI+WcRjsgXOxLANnUG
	z+YN0qLu8gSp6bwH8PSiJjC9YQjh1cA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786119533;
	b=kze6+4yBievuHnLursVffGiKZvhvCgkjdhr5b3CsjCj/B6aompRNHKK00DXv9Udh3F70ep
	+8F0CkxWKa1jAcMa7CWdrf5HlIaZfkBHcrjChX6iry5CZqY+zrqnlMA4Wmdb1T3K109jL3
	IKze6rvNgjfw+1eEYv0j+XNEYa1nwxI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LnPjT0vY;
	spf=pass (imf12.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38e347638adso4000956a91.0
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 09:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786119532; x=1786724332; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xPAASAJMLr9J3CqKbh9dNVdhMzyGvdXIIGCu3+XVZNA=;
        b=LnPjT0vYGVYraIe8HMH5MUn8LTar8BNmLE/zqqNPONcg9YGx0v+6nyVBxtn6QORoaR
         ikJW1YmpDXesRJVS416HntouxJjIfIyfnvGAHKxAh5FYtZkn/ZbX5k89czjbBCIbkKzz
         0k7WmxIFGzw/gJib+wYHWR+MMxDCgtXcc9UGZgcSTvZ0V712sPR9mvX3eYTyGeaKQN4O
         9O0swoBvqcyTTfyuYPRkLGiZqC1IKaWihiQOVSWKwyJg4vhcDph9JOVjwm5K6MvSqjEp
         PzYqE+52Dl2rqcvrU/oqGQFPIxsViqZOXCZtKr71rpMMQ8Q+e75YF5mPRsH7qj6xmb5F
         A/ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786119532; x=1786724332;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xPAASAJMLr9J3CqKbh9dNVdhMzyGvdXIIGCu3+XVZNA=;
        b=Pp0EUfX4S7kc5EY3JcP1q2jlfBD4wksdEjmIDAwkuNAvLphPAG19EdcwjDfXhTY8mz
         Kn62j88Wj/aO4wsn00K1dTQ1n4l23ALP5BLwmLMwGN7Ns6lLP/QXGgHjqZCKU1iWBoHo
         zQ7vhZI1noIQ7j1xe2c1g15WGv0xK0FrIt7WV06yJ0rE8B5UfiyrBTTKQtRyk9/LDoAk
         eL4QmD8LoYAXcSD0ekM5QGSCjDey46rJAcDuEk7VFUW7U5mnIO/BLeUk7yrbfGbcnvc5
         tAOJc/7LiWHbQZ4hJd1yT+8aOI0juBRPgGZ9mRJigkCdMNBUwh0kmKjO+2/iudwMTfGC
         mvgA==
X-Forwarded-Encrypted: i=1; AHgh+RrmkPc87J4ExuoxxaifwOAA9m7bWQm4ydoY47GL3d7mDDNfBYKqQjZjOHzmopOi3qWPHX5yEfrDxA==@kvack.org
X-Gm-Message-State: AOJu0YzDz6MGCVj6uWUp+4ktuoP/EIPpvbNeDMoBb3dBYsrX756cqMfd
	rKvP2nud/S7ToYwMT84DEevLo8UHKGqODSS0Z9gUScM5E+q+ofDbJx+Q
X-Gm-Gg: AR+sD11LSSx4IUeiux4WzDoTFP/AeZrcGS9Brz9kWMnSbPrqlKq1XJI9XBm4Z6g0x6w
	us4fINo37no+if/HcP0dy7GPpXXOUYI3bUjRIVgEhCR5FMwd/0DlMBbDzBMmeR3kxyY7Ch4vcW4
	N8U5KGcUT/FmFjnNqlzvrSta3OcyoOsSakRNX5HR9Q0Udk0jXcM+S42UIs3csfafM3OtVVbKL/S
	dC61A5xjI0PGgKTrv6gv0mrIfytZt033w8e6nppMfl5ooqKop4eCCN7xyHA5Ew/mpSwkfb+AYLV
	uelSTVXEoT3kRvq6XeLgMlKDH8Q20YZrR86rRIOjUunA+0SlawQrqUZIu4O8kZW4/vT3ewTUzym
	BSWH9Kz1I2r4+RTlbPS4QK6zyE5EockdKLRIKdmO5V34j8xRArnvf6fkpmryI+abn9amzJk9fIo
	qB0IxrsJwQq6d0QmjLBIf5MjEff3Ad4PS4xzzC+kPCr2AubShbg/Top73e25/uGoSAtsEse1Fyi
	wChbrta5b+aktT3Kg==
X-Received: by 2002:a17:90b:4c84:b0:381:c500:b0d1 with SMTP id 98e67ed59e1d1-39282554a40mr767321a91.20.1786119531993;
        Fri, 07 Aug 2026 09:18:51 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:935:f4a7:6f5c:e816:9aba:2090])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39086164982sm5488522a91.16.2026.08.07.09.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 09:18:51 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 0/2] mm/damon: fix nr_snapshots semantics and max_nr_snapshots check coverage
Date: Sat,  8 Aug 2026 00:19:00 +0800
Message-ID: <20260807161900.57054-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807141214.91390-1-sj@kernel.org>
References: <20260807141214.91390-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4D0D640007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: cembzhnjxihs9n83fok1nbigrn9h43xm
X-HE-Tag: 1786119533-790960
X-HE-Meta: U2FsdGVkX1/E3Xi6u/YNL6I06/9rASCyyZ/5lS/UFtmjzqHE3nnh8oE3AtWNpjoxHqqBHj51AM+fWV3rI9ubUpKh+cqRqWHCTfj4t7nXUUZcU7Ix6rX9aCTtmfEPjCloTBq+X+kYbKAiDCiAmHJleWwTfRqGyEXCnK/jEpE5T2YYhqOl/TJ67AK4fuLcyj9eBKE6Eoe/Z/4+AKAz1LWGCCJoZyYM4hscACJGB50oWWkFlr03YGVulyqo+M7WcEpnHAbBjw99tiDn+sLszkdBNBmGoIqq14pwtNEyCQC0hwaget45lOduDLxZ04T5/9grBzsGgCEDYK0AIsDoZPcndgdva1Fyc6OlzpmfP0qlwQ+Z1en9sMAs75aEYZnQGCryyfRQXEmbBbSLN1ebvNKAEZUmXBc8vd0PEgZ+3xOq9AuG00B1y1tcbROxdY78eqNNRz7Q082KyQ23eyFHapBfh3gc/UfxAkvEUsDPPRHZBVMd0oaowW8Q4uq3SuWhSgBnRLVaDTYcw0xNSZtTsjCTA8qW+Ethbvizp+pXK3saqOrhw8jP3Jeouj3/CkqE0eZoHvlH3P3hYCw0NzaI4WYE/Eju0ciusuxuqeyEcjWDdvyo2UIACEe8Wip4g5vy5Vwvcc0UjGeeS+1N0rlShngLLtSDrZCW07I7Lchuw0M9OPw/o4I1A3CAaFkoRTObox3ziAXd9IhC91V+DXk99YnPVSbpKdCwajSr9JW9ydvue8WjjK9IqGDVOwAFSD4mD3hDhmHKdgqlt3CfWw/kevJ2C80kcc2Y5bLHKB26QM8GanN5CNjzjQjDgY+7caJnlg+3a5uIOutsT03D2kXxIbj+tLmuR9EoMg6ZXlUU/ZAxswLFI15i0LC6FNBN9QpG8G47FswI+BFuZsBZ70izslDtezy1cuIr5BMR7pUD0Pte/lUFpnTjbPqKQXKZIAFkGbBb3NkuefEKSq/lHd/emDD
 HjcgN1py
 ElRe6VhsMDJJNh7mv2nh0GAgf4FY9nF/q0Z/arc/PNONvAk9bijCmQpi7f6LKwjXPC/JWGLmLZE9eN770Mj3pOe7BIWWBUQnJbE6QCqGYyd9hydiSS/vxM2qD7vnz9WJX32WS6ePoklDEWRYTl9ufVz+aS9GaNRh9tsiE35EKvbD8W5Ot7HIWidlItWQkO/OPcHS+0W5x6cRdCFGT89kDZYljVerTe5HX0LRQ4C1non/6QIsEvMDSTpdmwaEASDfMHkpolEr358CaMyAf6a4ncNh9w4V1nnnmhgTsfi14FdqNbfvrCZyEdy6L5YEDJhbluvR8yxiDJvN+3zaqIqGfCKZPFKK4uEFDyRM0IsVodgh+FMJrGuuFwe6kK++GmUBQ4a+oVUzgWLJfbxrMHgUp/QMWa6kx09YZxAR6594E3+gd0PGvhkn54ZJ4VeTPRu8zAdFa25eoLaUwLUAALq8/ZWIQ5dXlVR+VdqYAbmJeJuTWUx+GN53dX01oIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On Fri,  7 Aug 2026 07:12:13 -0700 SJ Park <sj@kernel.org> wrote:

> Thank you for sharing this patch series.  However, I don't think the patches
> are fixing real problems.  Rather, it seems the poor documentation has confused
> you.  Sorry for writing the documentation in the confusing way.  I commented to
> each patch for details.  If you want, please feel free to send documentation
> update patches.  I will also try to find a time to do that if nobody does.

I will update those documentations! Thank you again for your detailed
explanations.

