Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D616606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZEOu3fTt
Received: by kanga.kvack.org (Postfix)
	id 798AD6B05B3; Mon, 23 Nov 2026 12:36:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 749546B05BB; Mon, 23 Nov 2026 12:36:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6387C6B05BF; Mon, 23 Nov 2026 12:36:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45DA06B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:36:43 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D83BA1A0975
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:36:42 +0000 (UTC)
X-FDA: 85467088644.01.171243E
Received: from mail-dy2-f6.google.com (mail-dy2-f6.google.com [74.125.229.6])
	by imf10.hostedemail.com (Postfix) with ESMTP id F0929C000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:36:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZEOu3fTt;
	spf=pass (imf10.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.6 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455401;
	b=qiO5SLzn+1v/DhIUfcCDoaMCLUhcUSsxw/Qg7j2B4gvWLTxhRurTVCNsRWZQbZuaCj8+mE
	cPCWU/rm3dDgiHvFcXK7lNBGWiHqvEXBtcwGCv/omfLTOpimMEUH4I5xtrWxcApURUh5RL
	GfG/4RWUaJNWNYAFCKngFnEq1Pss+fE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DK0SDoEu6QZPZO8EwpxdCqNFA6Pm7zmMkL47ds9UeV4=;
	b=WI/jgoNYPz3juITEvjDz3xJGEDcFO0g0Y/yPNm/T1g6JGxVUrnIqblwbh5+SBBX4sw9qJj
	eo4n5Gy3Zbl3RfBgVmOIfnUrtGsLQpfhhzsCXr3QACE65xLUydQKfdCJBSleO/sCF6/v9i
	fjUq21qGZ4T+KxpXbHSUx/XyjIIK8Mg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZEOu3fTt;
	spf=pass (imf10.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.6 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy2-f6.google.com with SMTP id 5a478bee46e88-33e48934fa8so670630eec.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455400; x=1796060200; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DK0SDoEu6QZPZO8EwpxdCqNFA6Pm7zmMkL47ds9UeV4=;
        b=ZEOu3fTtx0hyrwzo3J8py4YwgRe59KPX+0e9o0t8qJnLgCh4hHtG2EWge4ks3lZs3q
         YyoUKN36dZGaQ2n4dJjTkkTvicMmjBEE9e6b+raeLGOEh2R6QEZxE2H0CtAQnltG2j+S
         p5SkDC7S8Vwp9ILM3Mil2Cq/F75armOVHhEodrOA56rWUG4jez3H7X6+ruoilR1sJ6tY
         91R4hoGz13GyYI6Tv7rJNomO3kw28qLRdhcWEcx+xEL716wdkRf1YIjaScn3M8VVlFJE
         EW8v1uq+mL6e61+LKpYyehuWm+uVOCdJnaxuNbuY3HYeFEPsigjdxUUjIDO+Ov0R0vN+
         icLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455400; x=1796060200;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DK0SDoEu6QZPZO8EwpxdCqNFA6Pm7zmMkL47ds9UeV4=;
        b=XQutLa1qLlv0rFm1J+oOJ01M1x9johJgWxZcxD7KF+DNPZ64HSui4q4z0AZpLPCfM8
         HlyS43mQnm7Sx/depbnU17GmAMCHY25JPgfYFeiB7B4+JkcVZDoDg/iHgEMUjDT5ucU/
         lVykl8lOiudAA+BMZizA7JPL6FRSXbuHh9NgZlrconOdKpoQbFfqEI3sDDt7r1vKpOss
         cOPc74nL0wbnWHnP9Ibqz85zaFoHJyFHJVyJ+1RNRiOfd7O1knZyn89miwkWsmJQVTkr
         okIs4S86F5OOrSeaE1/a2idNNOWG76K8qlSCObLfSpHcGBFW8K2OtjKKWb1P3/LaNfTC
         hXWQ==
X-Forwarded-Encrypted: i=1; AL+hErFpUXNpCxAqzN+AG6Sh7KVx2Dxt2Ex0sIDgmqGfCiPMxE39lz4Ug/3zs4KhQ8Kb6o/z63bcsmaWFQ==@kvack.org
X-Gm-Message-State: APuU4Z9x155N62a4M786g/oAOYEUDj8kPAlQ0mXb3XeOpAkfv0n8VMfi
	46eedZNFQrbdDm9J/2FShpmWiAOxVYCk3o1VMHq9GnrwjdbZQn5hqhPQ
X-Gm-Gg: AZFdTZcxhaUnESBeC1y7inv5zwjl5/uEXIgPWZhk/GviGOyeGY14gW3iwP5cmxeIB8A
	rC986yiQbjPML7MRaiOXrLu0eDE+5M9QqJ/raJd9L2Turwgi97D7ym/zXw6ZSTk1blbzvh8BdBa
	e4qiMa5DCcbp84lIDLLsZiR7UYDCZdJOzfT+iZPZNvv7rOgizQ5pv+E1C/Gx8P/MhK2Jj2rRKyn
	oW2c4SQPOHgSyczzK0p3AheD/pFbJiyEhiLgpW/2X3ihKfZEDd2suEU/oMQJFdIbjhyMcQrZ5jH
	kc+jts5UsZmmOsTPXfzMMkKdRw3F5kJjdh45U1scyOqvHWkwakjcHoQ6y3uE2EtifKTWJDGuWVV
	c2GPcObBrbucH6qN3fpxWNcmLqHEch+WIF+k4Su+SD2uz2C89252JwaCRyVFReTATQcJ+Btz7XY
	J9/Buzy96GZN9E5kBghAS2uJ/Bk2aeq7Ayzcfq3pG+3e51rWCVOSuzrX2/lCeTUUlauKHe2JQgD
	7rCWwQW8rnrCTcIPHiCCJv5FUA3GT9Q5ymMgM43dVy8+fATMFozqQ22YsBSFOZ5pkUxeaCVqwrn
	c6VBDUaVVJXSbW20NWjc62KsDbrjMr00N+bKjEtTeJrSIAp/nItOFslOUxjDmsQGxK+Vhj32Ew4
	WLweWO/ieS9IF4Vj28nkf9KcPjzyE4LTO7HnG0jyOvcLLCVCv0/5d3XQi9XMtKg==
X-Received: by 2002:a05:693c:600a:b0:37b:4a2b:81a with SMTP id 5a478bee46e88-3863f13587fmr10922069eec.4.1795455399630;
        Mon, 23 Nov 2026 09:36:39 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:36:39 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 10/27] Docs/admin-guide/mm/damon/usage: update for
 report producer sysfs
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:24 +1100
Message-Id: <179545256499.4.15497978395841877294.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, damon@lists.linux.dev, 
 Lian Wang <lianux.mm@gmail.com>, linux-doc@vger.kernel.org, 
 linux-mm@kvack.org, Randy Dunlap <rdunlap@infradead.org>, 
 Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261121210013.130397-11-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-11-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: cymi9smdtpmuw448psmzynujwqmj6tsb
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F0929C000C
X-HE-Tag: 1795455400-241038
X-HE-Meta: U2FsdGVkX1/tjUY7E/hr3ufa7ohudNoLZgSxMUAFqq+Agm7XKwOJ3kUKbxRdwCQSMDtJt/B2Ij1LUCJa7vnRwhQl6RTnIbw9OSJZbTj3/O8+oqSDfEpXm9h8TkRK/z4do6fSOfVxVtXIG75fqAL4Yih6NX6iXBEFcYck5HvVuMdIyVtkN8TQXhsicv2pRbco+f3+eCKGklwHCyaistUCxRp1EYGW19kE+UAnm4zUkZHmfe/PO4yX4ZHnCgoE8myVQ/8WFBIlPXWAYTVuE+nAUZNuw7aLM9SIYbgu6SmFCVxMMe6zP6F2ZPwfN3ffYMGopdAkzJCtjEGyuNJi6Tm1/JCsTYijCTDQ8Wl8Q6deJgzg7JkGFPSxHohOQtpVJuPh2tgF+6xoN17/q5RICtY2jbVvsNZvbbzloLxfMelCNH6sMSJiZeyI9XqEnoyTsdQjRQoAHV11ovFqvIG1ovqMzNAo8DiV89r2vRoZyO/xKH4H4FZmxut70I+0JWzFHgKZnHyfe67l4mEu5KNVSENAWb9gfxDeja0L+hXL57OmvDHUuCVXvZ0KguASqPa+/+SJIcxn8lKGlhDduarYp/M2ZX2G3R5Qgxh0H5ZkWRQnASk/H2BwRhb+aYv9MeisDPQTKAxcNCKur7KuMFI8jmL8fKVyhm10Ic1s1x/LFTWLE/OLF5LU1TJvjlCLtBgSLY16BOzQcTxcsC/VA3R9H7mpyf+czOOyrQmwPteSqbTBN5IBqr5kzQF1G3UIZ77AAiACnEckdd5njidCAHGaFyX+9dIWCnb+XUYAsIdyJXP8cVopLb8NcT4lnewpf7p952Rgbmt9QMG4NSvq0ex0zXf8h8AtopQVsI2TGtc8mK4GiTUzdKdf18jKByG/NItFmgETIRsMWgcKeKJLDd5zNJqU9tIgt66ZQ9dK4Y4I9F90cz90E9MSrHdIxghu6txguueM76QSKmcdx+yidZDkur0
 IKYK69hm
 y6UdzjEjvs/mV8B6tLguZcNeIt82S3JZMk67OBmg6VbrEFjVUjvU0uc8U7GMf/ehXH0eRTxCZtEDHw89Wx2a9K23UYeExUGvQ7uUb3DMPUm+2rZxFixTTxO1l1AX7kOScr6lOK5gBw1H0iRcBZ1+mgkwl9K4S83jmF/3o6DffTujElylOt5+thgqpbgNWoejqDxU7wV5k06mZB1ap6aNUdCNoxZsfvzA3DNGK6FCMOV6hhCGXy6XhnyyiUyEM1VcLzKFRXfgdypREOc/sKdQiY2CgNSFBRBunOo+fe9lmEhXw5XEF5S65DQecekSGWsC3auC5mImelx8yBwEkj1S5Yvl5xdxCgRXfc4fb8///p6bWfQQy85eCw74tYV9SMhWW28DvdpPt4pn7INgpwIFwp9SaGWzcL/zlbkHtdhcAXE1+M68kAUPg0iTk17Mg62ji8Hr3MB7qkUp7wcPci18mm1hW4fcsinhfC2YGjnt0QscsroauXiZTE7PECEsR90z2owX0MEwRsMRuVkzmga85qYOG65YyIJdY1+x6bosBhsTfxuGIhwGmyvjq7dcCZoWb/VePlgxH99i3Hd26M4JaJg+lOvbFzQA66jO6ymnlCvpQBtESruFKiSJNmz/8SlEHHl6lbCxm/KQIGBvqMWiKRz9rKEWijAvJ0DhlGUF6HQiSncNnjqQEutGn43EuwMIQBX0YTXSVR/vN7OgmF+BEAnIGoiBdNw/I2jSZo54W24OAuFmmvao+81Rr3PwO0vNTIjIjegSVhQy04wJ1E+XkEraPFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 12:59:54 -0800 SJ Park wrote:

> Update DAMON usage document for the newly added report producer control
> sysfs files.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

