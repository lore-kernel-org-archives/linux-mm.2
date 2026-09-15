Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6076C88E72
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 01:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EF386B0088; Mon, 14 Sep 2026 21:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A0D86B008C; Mon, 14 Sep 2026 21:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 369E76B0092; Mon, 14 Sep 2026 21:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F04B26B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 21:57:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6BA7A802E5
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:57:56 +0000 (UTC)
X-FDA: 85214335752.05.B943A87
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id 97CCD40008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:57:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hYIMpGPd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=qwjhust@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789437474;
	b=5pXk+pbhcrHS0oR7nrkIJrb6uDV0GscDWiEHBJLOxowNEBb2AUhgbDPPpo6by8rjrFbJt6
	2WOKm3bUVhT/SMjS9P53G0euATIAex0ZcKyhe314lrG2louI5MzhMQv6ypsGHTradS6Lkf
	m50LNa6hyef3ANMIQCOiMuvNp87hO1U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hYIMpGPd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=qwjhust@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789437474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8LtHfoqQuWljZWMj5fNvShJKWJ7Eo3q2bY3EGg9Y51M=;
	b=5+tFUc89GHiosin/k4Y4LklTY5r/s807ZikM15NnoEGOa9jBR0n5jtPnqBn8Xggv7Ig5Yj
	lkY0T+0xzp5AH4THnmrVS0bonicQV8Z1IwvPMhvYvUU/Tds4WoxzreIssXZAWndQmi5Yq0
	DnmXLJh+w4rUUGKSEuVS81CTnSHzkho=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-86aecf49833so25936b3a.0
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789437473; x=1790042273; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8LtHfoqQuWljZWMj5fNvShJKWJ7Eo3q2bY3EGg9Y51M=;
        b=hYIMpGPdA6IZzrp3iHwAF0pr/vo+LD4TJu5eRy/fWgjz6I1LEFlD8ocwe4WvN5AsDf
         PPp/jY8RHjAu6oX8sSiub04YroGqcSGLt2mG8f3MaC+NGsF0sCOOUmys8LXGIV4/k9mT
         Gz7DzQWayXJ+AV5vtC/Mgr56lJPR0c8uKDYIq+IWdHVy4iEiMUEg4Ng+BaKaHROAXtDT
         K4gRvqgSDrnyXx7UOg97kLxcUwqO+jp7iznxKbTkFOEZcel3pF1x4p9DPNixosmkLYi0
         jh0G3HodC0pYqBVA3tazDwaNTD2aBk1U2m0b7nZTr//Le6+ObvFV81rubc2B6UCHYIao
         nGZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789437473; x=1790042273;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8LtHfoqQuWljZWMj5fNvShJKWJ7Eo3q2bY3EGg9Y51M=;
        b=cCAI2G7vTi8TUEkX/+akM1KuVwUi41rCIn/8qssL2/KKXC0BdQeZqoNSWOKtdpuNka
         a0UzKXqHrIikgvZNG1UvrfzGg94dbqs+uIvRleAjzwsYjP3WRoy8+gMSJew1vmrvoeqT
         roWa4BAoeMCWTCjBlzlKsrVnJ78UKBeKD5WoVUiiOMDtWDWyvEOg1gWDVf/UGrQY5xWr
         ekbVwsg7H7oYGtzf/vAfykurPZZ71CPI64YyTChhBlgj9m+RNSq/r2s4z6rHjS5BcdTQ
         KH5LVB218+CUcdhLHS6NLBwAuoS98wY8zmuz1rDBkoDmJhM6ZtOXAuTvMD4Zm4nZX41O
         gdAw==
X-Forwarded-Encrypted: i=1; AKwUvBwxxKbsBktHdhjMI0Yl43pNdxwJJCpcrlSsFrZ7jjYEpVHDKxs/B2tJb2Hmkfqa5BvlHXy2dU2E+Q==@kvack.org
X-Gm-Message-State: AFuF++kOkRRkfDnFWxdVfq4h5JdTmDLw32Xig0wc213JL8Jlx6PQvie5
	sWbvC6iFFt88RZTJvOBvnsSG804hxRm1Ijwed1VHhpa9HtWUcz+czkc3
X-Gm-Gg: AYBFou04jg+tzDFhRwTq0LGSaB7DuA9CVey5PnlfZfUIJjh5VbCtklmOEdQMGd1Y+Ga
	QhW8/teg5Um0Xbp4pnHxXfSmRmdSZQ06Bzlaoxbq1FxTdITPzJ4n9Kl4X60rsAErGOCS80d2Oxl
	qJNw1uWa1crAKbMm7aeu4W/IkMCUn1Vbgw1SiVZnTswGEXTrNwKv0G66bEsq2fe0D+BFtXYzF+l
	UPRLoM5F0qvqdUapIL1YWdV9mgMLFYalpjvre26F7iZFeJBK2UbnChVkw58+QHK55hcbUIV5n8g
	EODCgaofYMOZT3A+K50/gIfJ23NNmH+VWel/E8BbiHzeJBehmKX0MjnlFY5XunjcF0eFWpEvoHb
	wQz5BXnjXvWfLxFxeE274yshUkfFM6GIHSsoZRO2rZwYXKzpSQOe71s1h2AHpbtoRsMFBEvKlCm
	LaPwZY1335iJ/oq8ic6BTeeRkN+wxJgPNUVabfGjCWrBm61OSwK8QRp70gD5phbX7Q5E6mhizya
	RtmCoj52cVceUnJYNYBbXsoF39gMtfE
X-Received: by 2002:a05:6a00:3a01:b0:86d:117e:5db3 with SMTP id d2e1a72fcca58-8708c45f131mr2265230b3a.26.1789437472373;
        Mon, 14 Sep 2026 18:57:52 -0700 (PDT)
Received: from qiwenjie-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b6139e3bfsm5231011b3a.50.2026.09.14.18.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 18:57:51 -0700 (PDT)
From: Wenjie Qi <qwjhust@gmail.com>
To: jaegeuk@kernel.org,
	chao@kernel.org
Cc: linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	hch@lst.de,
	jack@suse.cz,
	axboe@kernel.dk,
	tz2294@columbia.edu,
	baohua@kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	qiwenjie@xiaomi.com,
	qwjhust@gmail.com
Subject: Re: [PATCH v5 0/2] f2fs: enable buffered RWF_DONTCACHE
Date: Tue, 15 Sep 2026 09:57:45 +0800
Message-ID: <20260915100000.1789437600-1-qwjhust@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788795700.git.qiwenjie@xiaomi.com>
References: <cover.1788438786.git.qiwenjie@xiaomi.com> <cover.1788795700.git.qiwenjie@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 97CCD40008
X-Stat-Signature: d9qrmcjw8o9i5o7zhyximfzoptb6aeq7
X-HE-Tag: 1789437474-306541
X-HE-Meta: U2FsdGVkX18kME0AfTFvCnk1ow3/sL1UJVpHlLeiT/7UPPDkaiKflTDNWQ35HMq+A3InSOv38zoFH+T+SSphHoC0s33OhjcKXbkPGo3QN9rRUnT+v1PA6PMshF/3RTivwQrRhf+TAZCicNcgfh7lzdIMjs37L7JVbbf9PsVUaqa6XuLVDy/ylPAKmT2cMOQuC3aUzb9Gtesmjrm1Q7IL7LsIwGNNizK7J5WXFpwwwW/6rCtgKp0rRDYtxyw5gUf9iH0KEjJuWVI+IH1kAHPHXZ25V2TYYoqUl/ehmv1CfzIV7AhoAll/8+L5/QZpowBpJcfC/rqo6TmyUQQqTh/1DBk6fYToywfFm/K8pQd+XgZ2hXsZBw4AszQNqVgd/uI6xfMscur24w6XDhwJO+bBZHtAnVCypmUOcmxAoL4ApPHhzauNOb0DmxpsCr4cumapVO3IXdnMHalHde2EwDL8rkmR+A5H8T2uqACwrVCsND+ztbJmnKdRjcWpizj54m42u0mDoMlstcwEV38DQ876+pMILaKviXoT++0YbJiG3HTDlQ3Q7A1E6uBF7tWXUFa8N8Roh61eULpLusJ/Gd2rvmrBTCzpFWTuNOWFEhkAEVcaeN4WriXzLYv9bvzOyxoQwzPpT7yjgpijkezPRlr73gw/3pJidEn6As7uOAtvwLJGZDyvrlWuXaRRf4R6sJLYJj0Vxb4HQQ2YrDFOe/reYxeLfN7rnKriQkpKpQPt9ft3dUADHmOZi1mDKut4JugsUQwyOrA9O4T7jojWd+147ZBC+gcdKpaemWuIHbMXZ/vt4xbFYVk/AzSvTS95e/Wnw/2hvIjsPggyDfhHmALVLOA7qXSj3XnQSYHsH6/mEnReOgmkEPmny0fBmgaev8ev0XeBtnb2kn+SVYZltCBzWV9ny7nBfZVbCbKUZYEOFnpk75dDb9giaBxug9MxO9Z7j8lpMAO/whQnWeeFg4Y
 srAEYbFf
 z5Nl0ewvEYUrTBQHiZvoMZeCpc1g1l0VWTSt0P1+YapLE1JwXqfJ6W4CaJDm3ETJk2snrpnGrYC9i/ej4O2G25HqcO782527QhhtF8RGQrC99b3WjOXeyB+6x7wFmrXEeZqj4pJDqaWhcVjkE8oKKEzI7qLYn0BEFeftu4sDdj86xE1g/SRb8iRVWTW6sHozsV3HPHuX3orEJafJR+UOMf2beMAxVTEGqp/E9YtpZpGrlhphaKEiFQKglZgnrbMrog5++8gKNnTSE2ZXmggxOS4+QMQnsOBcGvxfbhtd3Sjr+39PgvPcJa1+Wt8XEMLbBV/0rxTED0a96llRSAKfHMglA1+7PtyJRPSWlZ2bfyLuW+7SJP9UhSusamXq5ZZlNZRobTwVZBiWUH+ijCmngxTHkrsoFK+dcDW6fqI3m7lYCkMwyIcfhP5dRSOyZYCkjwg5V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jaegeuk and Chao,

Friendly ping on this series.  v5 includes the mixed-bio completion update,
the syzbot NULL-kiocb fix, and the additional memory-pressure data.

Please let me know if this direction is acceptable or if another revision is
needed.

Thanks,
Wenjie

