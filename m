Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7B25606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=If4uzVok
Received: by kanga.kvack.org (Postfix)
	id 087E16B05B2; Tue, 17 Nov 2026 21:01:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0604D6B05B3; Tue, 17 Nov 2026 21:01:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDFAA6B05B7; Tue, 17 Nov 2026 21:01:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C3ADB6B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:01:48 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 154C5120637
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:01:48 +0000 (UTC)
X-FDA: 85446588696.22.E2B3E17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7D2A640004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:01:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=If4uzVok;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794967306;
	b=g7yy0NgfFdgrwaqxR/a8ZSggs11HyJfMXTzbQXSQbGvfyjl1Np+Znf1npNTsNrc4DAwDQt
	tfXBfxZardiqRff9cDTK3aEbJ5lnpbg5m87WBDurpnd+e/Lb31MsWyMHp8ics35f0rA6kg
	K7PCsTpPyJ3mDCd8Themzbjw0d/iV3Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=If4uzVok;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794967306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ModsJ7OTyhdOku5yOd06nJCLRPB8N1jTa1okgDkwSN4=;
	b=w6rKZHXSQtoVtvS/f5LrOZ//MggnSraUPHAZC6CQRT8AFSM8TD75MieHNCgR6xtALM9xUq
	RF3Y/QROERVKw38K3MYUY9svivAtFQLxmvhBunwdnW9qoPAUgFkTYvSj2K0z0ez/ofNkUE
	ID3CbXXzwWyPDIy1rxJ9m62gCxOosFY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A5467450C4;
	Wed, 18 Nov 2026 02:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2654D1F000C4;
	Wed, 18 Nov 2026 02:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794967305;
	bh=ModsJ7OTyhdOku5yOd06nJCLRPB8N1jTa1okgDkwSN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=If4uzVokBwbpms+48xpd3nNrPBsWL0U0bZATRysvdLzjIo1qQNPjTb5hB8+Uv20dJ
	 9UfArH1ORhOGOxA5y7BS+7YgYvBAse0P7e/K7cP6lkaLZAWxBe9Ij+c0JDp14yVtTx
	 CEPEIxS9Ykc+5KMdhAcbIovwVNQjZ3BZoHoM+v6hmzoHxnfLtFd1dbjctHYjQHrV/3
	 qesBkPaVVbkSl1NzDolU0qs1FOWnXQ47mM8rULpzvck5xgY8C/xU5e1yUeZEchT3to
	 KPt2VVSSRveuEiWa3eDRTT+Ig8bdK1xQ5SKr87Nm3ugRYVX/uqMv2gqj5CmQdJ9xke
	 MqUpKJJxnNPSA==
From: SJ Park <sj@kernel.org>
To: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Mattathias Pinchover <mattathias.pinchover@uber.com>
Subject: Re: [PATCH v2 5/6] Docs/admin-guide/mm/damon/usage: update for sz_ops_filter_passed_last
Date: Tue, 17 Nov 2026 18:01:37 -0800
Message-ID: <20261118020138.97260-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117-damon-sz-ops-b4-v2-5-439888fa04ac@uber.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7D2A640004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4rt51f3w5m834t38qjyya8qczk6my15b
X-Rspam-User: 
X-HE-Tag: 1794967306-503857
X-HE-Meta: U2FsdGVkX1/sWu8ZwVCLv9T08BnfRhwmL8a+/j8ABk061dGK0xGTrR83eh2qOFL70OJQ/l/EEiLznI7pU7WtfokzGyYnH5L1TGAB8qXlGBaQpuI8Ck9lY8lED5lZnEQ9jw4kVeP6JyOsg/347vbHh76JNfrEy8Hzsd3ET8Jsru9CAE7ZJBOyTHQb5S4KVP9jPDnhDbRce46O/Vv+s84IXrsMMQSakJxY7AR18jy2nidvoIrLjMWot0Dvr2bbuosX9PQJdzgiAUSaUFcx+mOJk38cCUFJ0CVnLEpFxRAMZfNOIP5XxUZq7wliu+yhNzM9zP/hs0oB81fiqOUf3gYA2KRqtYpVHk8XC35aX38L9xEF7Yoj0k5GizL1356vrqQY9dzxUy1D0w+3hnijk/SRhUJp9S4DrLmip4yPO45Ir+tfr/9nGZfyEAROC1xz+OcMEt22Zsw1b6MZILYsFk50z8m9Qcu5nG2YCk4D5pwwUsirWIAE3bu99/fyfh4k4n5EPoIbmOhq+brpalzip/94Ry3P0m+b1lqFfxoYd2JwjW8yTcdI3OEjo0kPHdrKGMm/94fV0RhBrhLD0k8peNnPFJym3qblzRkh8aFEe8IoSgwwD5c3YNqQo6Z1vX40ixKTwwXxEHMPnPCggrcKVZ+wehXKyt7mM1CdZvTXl5RZZkSigm5hzQYKul1XPhUFSBHtfcAIgiTZo7mo9vFZcPGQDfT0QRXH3t2c3anZUlrmwcXas1NdrOZEZqxxrYJVDua0GFNRzLQttEvhDU0HRo4s+75r6hYpECzkghLqWGF2maJk+tEKYbAYzUciG9YZ1ZCh8EEdxSxt333fVEzaxYhYqTxkUiJMaIbKpgiPOXI5PDx06eGmohMjECfjH9uFWBpHcyr6mimoS22uaKRUEKT5kfxpyt+HRB9ro5iaze7/SeHAHBm+lW0FsgJVc4PzYUvOBASdqZ2OAcwbu+/QTiP
 zNtgTxbn
 UepVDR7ATHbGG9gQ0Uk2Q4ZXGbqvX6DCl42+mvpdzhQxgNpuvGTNZ7iTCNiRjh2Xjmkl8+QxV8gOK6py/Jfe5spr+sjqn7STz5tIOggjTQmU/9Iq+c6NapDNOlhzjVe0Cjfu5iET7qd3umnvTb0gBu5e53bTRI0CoJ5wl7fd6MekQ+4nXTNwJ00HtMLsbvL6yoDOChEu3dbCjTAy/upDQsKxIG+8Dv+500FfgFc/hiMqgJRH/JHi/IEx1uI8RRZWnW0LH7DLxeaEX0PyLCFOhnkQFV+nir/EnmU3BJN5QeDROcaapC5rULSiQ23YFunpxYXzE5oYgGUTXMcZeei8vVgHynecrjvRIlHQpcx7G8CWuU28xOx/qimOXppv/wPeJQNRB9Tf1vRQnnUxnLm/iKU8stijpcmqkCbh0lXygIvOehf9DLdEclwCJl6bxVX/VXIk9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 23:22:19 +0000 Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org> wrote:

> From: Mattathias Pinchover <mattathias.pinchover@uber.com>
> 
> Update DAMON usage document for the newly added DAMOS stat file,
> sz_ops_filter_passed_last.
> 
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

