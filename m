Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1556D606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 02:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rMsou7hH
Received: by kanga.kvack.org (Postfix)
	id 1F0DB6B0B5D; Wed, 25 Nov 2026 21:09:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A0A76B0B5F; Wed, 25 Nov 2026 21:09:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E0F46B0B60; Wed, 25 Nov 2026 21:09:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE1AF6B0B5D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:09:50 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6885A40270
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:09:50 +0000 (UTC)
X-FDA: 85475639340.02.7280A20
Received: from mta0.migadu.com (out-128.mta0.migadu.com [91.218.175.128])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6352620002
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:09:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rMsou7hH;
	spf=pass (imf13.hostedemail.com: domain of enze.li@linux.dev designates 91.218.175.128 as permitted sender) smtp.mailfrom=enze.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795658988;
	b=sfBcND/P1T5p0UP6f2mrjqqrnKoZdbhA7Rhd4RsVY7oLh9fR+SGZSe8SfVAPM3oNwJ0uAB
	GGXzf6qahyWwVIPviAIOR2U0siFi0/OLPzIpIv8ocCYhl5aq2H2LjL8Cbzb472+ERad9p8
	FTQJM/CgeH+rkxomPv3IvMyk1hRimLM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795658988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFCJnUDvI/zg1+C9IEAmU9f3aSLnc5uju1bEjEaUAKU=;
	b=ZBSwABfHuIljOoWe0baMZ4DeIq/ivmmHTN6AxhfmdhbZ+5FwnUJVZB1ZkI8Gf4EjI7Mv9s
	s8J0UnVbDgI5ciVbxy8onOjCiCzxI7o6oEzNMURDxN/Dav6h7dalBpa0YKesHoRNyCZqz6
	qqJcA3fzyQa2KjHd/kiQcZY16zof8IQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rMsou7hH;
	spf=pass (imf13.hostedemail.com: domain of enze.li@linux.dev designates 91.218.175.128 as permitted sender) smtp.mailfrom=enze.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=iPPxwdSBC7SlFa3kpJ7q0c07VmKdWjj/7qHY2bBVFek=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795658987; v=1; x=1796263787;
 b=rMsou7hHxIbftKxzemcNQukrZeleDw/BRhARpk9a8XZZK28jkPvgbHPqPjmCUjCiQJJlDe8Z
 aPeaS6XWgB83cC96ZdAnQ6Rxyp806lwfvcnkROSTVe06QPa+TSE3R9qIyB8mMmri+ewLo6KMTBA
 uZyfBFtC1Hi8C1FEodIdr0dc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3ff17c68b4d8eade;
	Thu, 26 Nov 2026 02:09:46 +0000
X-Mizu-Trace-ID: 3ff17c68b4d8eade
X-Migadu-Flow: FLOW_OUT
Message-ID: <842629d5-974b-4987-b9cb-0f0792e3d69b@linux.dev>
Date: Thu, 26 Nov 2026 10:09:44 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Enze Li <enze.li@linux.dev>
Subject: Re: [PATCH v2 02/27] mm/damon/core: implement data attribute report
 queue
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org,
 Aveline Noir <jm5905938@gmail.com>, Lian Wang <lianux.mm@gmail.com>
References: <20261124153636.91854-1-sj@kernel.org>
 <20261124153636.91854-3-sj@kernel.org>
Content-Language: en-US
In-Reply-To: <20261124153636.91854-3-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Queue-Id: 6352620002
X-Stat-Signature: ow7itgau4fgpmq7hspgptnqefdjyc4c7
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795658988-636431
X-HE-Meta: U2FsdGVkX19g2g5B8q3evwsYPSUPLMLBR9JIzer4sHjohZUuKou86OXdDaT/bxQ8WOsZTRzMOsaDgrLdJAcNTO0ZQNlI1080rn4gkoYvNeukxrUaTK3ZfJE592i3BvtKeP1b4b/JGwvR1DrnfdLeA+RM166I1Vd1PKQErYpdltSOgNj6HWcZjq6gs3Qb/iOTHJJz8lKz3BYM+piz45Ng0H3kQgRuGUfZsz4RL892VJEXa/YEUgMTlX/glVUY0f91u9AC68tEF5yWTB3E5jO8Uw/erApMYSvL8HH7JVgkD7uEgvaF4pC8t4qcIWP6pzzvPryU/9J2VcoIF24/QzOIvsXMsKCTT/xOk7exPmJSVBlAvQURmp2mFQdh9DtrCDw+KpUZnoLLSuTlS6+QjIjP6JScq7cxwkf4iGZTpXL/24RSN9zv8dK6mVE0D81eD0XWfp/RDxWq2y3WB1YCiW0sqeCDIQhHKgbQWKZ4m3R5R7hq54+RcLDhwYdIZSL0lQrawXt2ZJ4MSTqrHKNo/czeXh8qhEQN8uOxjwwLkfm3fkKaDbfX5fHZqLbtwLaKIK1g7WDyxEKrdCO4IThpZLC2wZvXTsv8KM2QP7+yDxtlk1pHtI/xHmgrCRzSQSVBeLA4UjbR5+Flb4Zm2YDLhIIv9z8Rqag5SE4BE/lLHtyHS+8flKIsgtErxtALDeR3chxbkl+E9CI+hOVnRA8BRfyqckdNzfbvRuqHoRgt4OmYURyWRezsKDA0JUxhFKKI1Je/e5yEWM7rvIUu+GLgETvYmYwCjJ4KCb0ESUw9Yvjz6k7J6S8yi2xuDTAww8JMjgOaCvURwnwX0y+p7WnAdmDOcYuaL50OU+MnrnOFlkvsDG5AV7we9EQU3C3xP4l0OuE0akZCSI+JKfsUtOczeRPHdpfPZtHWkRma+4QslXuHF+qYgrWOvU6pFa8OrUCmz5qfVQEY1MOcyxBT+ugfgah
 bAKhbhsL
 Ii+mR6Ed/X5o6F5/UDuLqnp7AuGRVj9VyPX1k5/Ek5kVOe1hSxAi8B7baxujNfWKN89bgwuTbL3EHjb29BhLA9zvHY4I9AJ1lEzLR0qsS+VkDQrp6E5MGqp4q9mK1upUl33tbCEZTl79zf2hJVwCHZP+keA26kWWCQSAqBvSL1qnMGzNqFCFQpayGqoY5HuYc+8BTx5QekN1MUe6tpWy8TSE4U6agE36JMdzoFlH2/vXiKlHxTJ9c8EVecwGTCoMLARbxDL+Rs3NmQnxxHHNFihnkwdLQXotebkv1P5OIB0BDm5vbhk6OyI1cxXv4/R67fWst9g5cCHd5xVxMvntELSQcoCyHYpZaNaDEiu4+Zd2lh83MQJ6hjutgAK94JVwqbrvJNI4juAFjk70Oh5vJ4GJ1bwqGm5eudj5nk9g2xRr2kkRCloif14JA333qc6FRYWjkwobGbtgrApvhLSt6ewpk2je4vZHMQEywkBgin3W5pYjiCHRc1sfpjgSPf/JQfE4r6xp4AnM6LKVS5a3CeeCgwTSC+mkrTLYoDOPMpKu/WL1eLDpzi4SwZ38Jlux5PMTbF85Ry9imiLL7NjvBtEMqlLkmMZGxYajzm2tEMyuy6RM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/24 23:36, SJ Park wrote:
> Implement DAMON core internal data structure for queuing received
> data attribute reports.  Initialize the queue for up to 1,000 reports,
> inside the DAMON init routine.  Destroy damon_region_cache and reset the
> pointer for the queue setup failures.
> 
> Reviewed-by: Aveline Noir <jm5905938@gmail.com>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: SJ Park <sj@kernel.org>

Reviewed-by: Enze Li <lienze@kylinos.cn>

Thanks,
Enze

