Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A095C606C586
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FYO7Z5RD
Received: by kanga.kvack.org (Postfix)
	id B274C6B00EF; Tue,  3 Nov 2026 05:33:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA9AE6B05B2; Tue,  3 Nov 2026 05:33:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9713D6B05BA; Tue,  3 Nov 2026 05:33:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C3DF6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:33:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E28F7C0397
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:33:49 +0000 (UTC)
X-FDA: 85393446978.24.17AB969
Received: from mail-pj2-f2.google.com (mail-pj2-f2.google.com [74.125.227.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0DAE2140005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:33:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FYO7Z5RD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.130 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793702028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BN9Z4rjr/QQvEFqoc3xGEEd37Gz2EGsQ1eWVAdfc5T0=;
	b=QHBwIFfOf0uiRbTgEI2RJqTAHA/wOZkAjM8K8UA9pC0H1TNfvp7SxWg49SP9H+n7gxKnXo
	aJ7Px7KHlkiMgFcGasDU5vOJKZFAk9ddaYfEandpaU7HTOWGKIDXKt0+uFabLEt92+qEy+
	vVvmHq/UwD3OCUN17Ji76VB3N1qZzCc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793702028;
	b=nRpiCc/BVBMdDaBQ0oF6lSE8+jtiyHWt1HyZAINKlHrXrEH5hP58/YOtu41cZgilCV1nXU
	SU1b6SMwb5DjezBVJprhPuAfOClEUKW5KD9PYlrHHCpgMWWfP/Dc0mGLzUehOjCcI5lnoR
	lfFaUsFKT2HD5BZwJsC46Z7CZjhfVp4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FYO7Z5RD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.130 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-pj2-f2.google.com with SMTP id d9443c01a7336-2ea19bc317dso35404175ad.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 02:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793702027; x=1794306827; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BN9Z4rjr/QQvEFqoc3xGEEd37Gz2EGsQ1eWVAdfc5T0=;
        b=FYO7Z5RDLh/6GY6Nk0pwDxaOielzOrQ11+LJLGecZD8bG2/MWJSuZ3vbadrNGzYK+w
         i9rY1KqWJ4nrn/v2O2506jPloua7MhBwmfW2OftpEFVZcqjlx3yVb8V6uvouFGQTZ5ql
         fWqHtckugYhqZEQ7S7W5VTS1J8qYhuwXe0/zlrz49pUkis1um+FEQmN7iKE3TN8Gf68d
         /y9YKFW3bD+G/IytO2htNMITB2C9OW1Q/dYtXRseqSEngEE4EMjLUMl2CZhKZISI4qn6
         7yg+bpSR0HSpQCtXP0u4hBMBXevLUm3ajomgE7BVA4j4PUP/krgj1Zojllj1shppaoWh
         PV4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793702027; x=1794306827;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BN9Z4rjr/QQvEFqoc3xGEEd37Gz2EGsQ1eWVAdfc5T0=;
        b=cPdyXe8lCELsk8rBnDP2Kf4hsX6iX84BLz6Fu+2ww+4IyoEnw3ricyoFq7FzdAOKNO
         DXwdkjHkoVb7rbSnAaZb0jOhQC33qO/EOMWITICGBtF6EVa/jqnm3geLupUyFrPEF8LI
         MJh92/C2CVOPBbMZ5gg5OykdP5aalYd3eoODW/SBEePLymIajwn+mzk3LS6FZAYKi61k
         ptII3RUWyWzAhexATSzu7zu6a1Wq58p+DvwnLWyFVSg1lYqpd/11IQhwh4rrwqeVbqgv
         4k/ic939AobTlRKwFznclciOdU1lBki4ZR2hKbfi8rK2C47HpM4pArMSkseBwng95+qa
         FUKw==
X-Forwarded-Encrypted: i=1; AKwUvByo1ak/WyLgvfWDBcxuDa2hICwHYKnXcXbTAV8p1kyi8wH9sQzMem2f/gDSwHE/ifyKw3AIsfPG4w==@kvack.org
X-Gm-Message-State: APuU4Z/a4gDQv/bzoYB+W0NYByyPQbNsGOr9d65mXVYVHVVT7bDvvVRr
	px0uahMcDI9sQl1PRV6RmzWeJk3u3IK5zc+PMrUPE5P6R3+98lJ3uV4H
X-Gm-Gg: AYBFou1GVGfiZZYvQICt9SBGq1itpkcvLY1zqFk7Tg49DpYFw/+fqSuiIS8yldvzQSN
	+ktUvaRyggeC5FJUwDLvX0nzN/mjeYPcmIIc9UNsiD6cmaGu3jrP+7M8HMYc+oFZy6/74F242Zr
	1HNxMyQ5rG5mUDKR+V40FglE9avYO0JoOgDkhMhoU4xmCkWQv+J5x36iAAuonAcudLTuPrMt1Pc
	b4oKKHk2JlJSUyyA0QkX+sIRon/thOmbW+bDgapUTkyT+mt94d73PBBPBr0e1uJ02Pdqu/2i3dI
	99YYHD+/5NVjxsc8ac+slhMNwm8y4/V7J8jwi30y4lmSPN8Bb4uWQd8BgjCp630/0yKWuL88oxN
	DFIEGtt83Zdp4lZl0IJnrL+ekIdKsOD9zt+LiNbn6MRXd5Y1tBbxO5TpDriv2VT8a+fvVBT7ixs
	p3IFcLQbnQVv//LY18a0EeipzxztqsgWI4lXOSomoik6yY06EeTDBbFLK22oUI01zgfFJta2sO+
	Tk6UjuEgQZ1CL/yzmlKDvwUEw+RcE3BV/GKKBWvLwC4z37vLS6XmnisgrA3qz0OA7J3CbYJ+Z1F
	2kex+DSgo0akFHzXv+z6W8QN05Kp7hNWyQvoMW3e+VRqqoqGUyLx8VcxEVFkOmWz0x3B0CSAohB
	p9/PBQj98rhZKjVLcEeCKRfRutMM=
X-Received: by 2002:a17:903:3804:b0:2ca:e19c:97b with SMTP id d9443c01a7336-2eb36405304mr129374835ad.5.1793702026750;
        Tue, 03 Nov 2026 02:33:46 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb3928d821sm38374845ad.56.2026.11.03.02.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 02:33:46 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/damon/core: use list_{next,prev}_entry() in
 damon_{next,prev}_region()
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 03 Nov 2026 21:31:41 +1100
Message-Id: <179370190119.71013.18301574509097172702.b4-reply@b4>
To: Enze Li <lienze@kylinos.cn>
Cc: damon@lists.linux.dev, enze.li@gmx.com, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, sj@kernel.org
In-Reply-To: <20261103100714.70742-1-lienze@kylinos.cn>
References: <20261103100714.70742-1-lienze@kylinos.cn>
X-Mailer: b4 0.16.0
X-Stat-Signature: uuiwup89b3t9dgbndgw4j1rp9tezamen
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0DAE2140005
X-HE-Tag: 1793702027-348393
X-HE-Meta: U2FsdGVkX1/bVYzpNXxzqvwyV1xlfAae7mhnb0ycDyWrFoIBt4yYmDS4YoGqv7ou/T8UV6R6IAZp4W3d5tnx22ivNZxKamq9w2OTA+V3HMrRnJQ+Emvl0IBNQ8XMXbySS7pqFIr5l0J5OqyDbN7ZtYDTsrfLLy/NQuWSR8TVo05s36a5S8wOdLvc/pTowkWbb6zzoZ/Rgkwh+XoVHyWOWS311ib0LA/iCYVOnod5jv4iXHfKOXwZS0ZfPYEY/+R7ZVgUdzrNRA4uvt72P0HCbDAyknhStmzSY748Eaw3P4O0AqB3BDXHfhh3ne2HueSziTUKDCZXljCWBcNLdLBu5Gj85k0RTzdCgiYUn9aZ4qkApT+pxHbB3JD+po4xCZxfkLnG5J4bcBm3wR+zOqxg9jq1FGzau+x2y04NCq+WF9/TkVGtNuAfA5sK3UN6q7G8DzTl6ZBbmfU8kw2LDfKttPi6aNZJVi9M0+CGbjT/V26WGbiy31veeOxCM/62X7u4x98HmBTDbuvXUeXU3cWpke7m5+dKmvWGhpZr5KF7tWyRPDXgjRr58R7BepQKFLZmIKvkpf4YNwgp2+hcp9LJYSPW/O8OW+jplE32EZgTS1tKZ4uQwuMWv3eIh1/Rbmn91p+KcT1eSbvcKwMd3NPRWq8qY3hb3hL9ET9ef7oeaygWZ/OCzNyiEnDZg7813AyhSlBGAalqyZDn+Pf2Q863ju0szKJ6fTMRM52v4uMfGfK2NfBxRhOasooadL/hp2naSnrjKEDQIA3rWoYfrLRHAdjkZ4HGj7PAENEh6TgthatjztQPBNiS3sVzgoH1evEWMckwlifAnrIZcvYqUrXuBevqBRb0o+omTWqAy/+u32CmB/Gp2ibcDZ3dc47Ajux01rVya3OFw58xSCrJ/2d0DCvByGHMMsNuQvj+9WuMefEKHIcAB4zS/ELhXwreZ1iUpCbcsDmdTAqv1l27xcB
 TTCNjOej
 IazsxMv+ljppxXs0iuYNXkU7w4C2pvEYNzLiSHtG+sAMRPlfClVvyVtmcN+G6o/sisfkZBKY85w7Pm1Vj6Cb6qhqerO3KELDRyni/RtaX89wdrDQzJLnYQ1A4JjHyeEuTcc0Bl9q69EKjLSBA+exkcxI6rFhgDFSgPKqX8AZZpOwYMhDO3k7MgLjMfA7UEFjtjHm7yW4aKQLBhKnkChnu4Abl2i4lQvTjY0nmRu7dbNbDir/ng/XBUTHfTSRaLgPPhgwOmcdSxZIJGUqr7nSIQIdLR7mLGt4g7ZuOHd7HbxrHbIyxy/M/JHtLkCcJWyWTAiH568dqMxDG1BidytImOP6wbfgOMAtNtLgEVOlOuJwVq66JEXLfQbwY1ng0zeclIzmHoNj7gZqR5qdsfg6eP2JrUPoFlzm3t4lTCJq8GHMj4z/md2onMTuKdLXu/QBW6vDEJuYG7MgvBC8ZNSYlRkZhvHSRZCBxChyS+QoR2eV2jZM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Enze,

On Tue, 03 Nov 2026 18:07:14 +0800 Enze Li wrote:

> damon_next_region() and damon_prev_region() manually do container_of()
> type casting to fetch the next and previous region from the linked
> list.  Use the dedicated list.h helpers, list_next_entry() and
> list_prev_entry(), as damon_first_region() and damon_last_region() do.

The change looks correct to me.  list_{next,prev}_entry() expand to the
same container_of() calls, so there is no functional change.

That said, my understanding is that the kernel generally discourages
changes made only for coding style, outside of other work on the same
code.  Documentation/process/4.Coding.rst notes that "pure coding style
fixes are seen as noise by the development community".

SJ, what do you think about this kind of cleanup for DAMON?

Thanks,
Aveline Noir

