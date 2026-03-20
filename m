Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F3C31099B34
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 991E76B00AA; Fri, 20 Mar 2026 14:40:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969996B00AE; Fri, 20 Mar 2026 14:40:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87F476B00B4; Fri, 20 Mar 2026 14:40:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 746A56B00AA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:40:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1ACF6160303
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:40:32 +0000 (UTC)
X-FDA: 84567307104.04.9D56F09
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id B153E140007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:40:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="F/oS7qqh";
	spf=pass (imf26.hostedemail.com: domain of audra@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=audra@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774032030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZPAOWgtG4SQHr42CzCQhbcxIcm4NV2vph/WXhLwsYo=;
	b=G9XFm8/eIIwOBCoNvQhhIsr+500FAexUSXbJUs136qMdjX1WZ2YJ36hz6w9aBU291WXgWx
	eIoJimY/HAz6XWntOa6l7mSNfcMsqEiwtyyjlRqTOLCx1H4xUfBkW5bQIBOyK+0p1HBssn
	7+KoC0p/OH+k2JKHiajrcUiU9hXuDwQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="F/oS7qqh";
	spf=pass (imf26.hostedemail.com: domain of audra@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=audra@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774032030; a=rsa-sha256;
	cv=none;
	b=UFXNu1cU7c43b+tIzd4lVFmNpsxZW6rYVkYw0yQqdV6yI5/4cW+ZbeeJAlL06oZDzL2Zmy
	FmXruc4UhtnxMXhUWW/os7jJEEzYASknt3rEqS5aOcMaZNE67DWE8673fTVRCJTe1NrGXx
	D+wbT+M4xJDs0aRoAI5msl73kFo4jKc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774032028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zZPAOWgtG4SQHr42CzCQhbcxIcm4NV2vph/WXhLwsYo=;
	b=F/oS7qqhmOBKg6Qur8ll6HZg/1uPjRrxBkU978CgeHXjNTNRdL/Z5UAW15ueRXp8g/K1Ke
	CGadl1Tne/58z8AmRGGHeXbgTiGqGA42Bb7qbg52JqlY8M08Vl8PPO6G8aMp8FRosu5YSv
	n5aZ4EvE2RXWxuokxDDpqsiQT8E6QFU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-629-HeHuosOpNrOq6Tg3VFKqRA-1; Fri,
 20 Mar 2026 14:40:21 -0400
X-MC-Unique: HeHuosOpNrOq6Tg3VFKqRA-1
X-Mimecast-MFC-AGG-ID: HeHuosOpNrOq6Tg3VFKqRA_1774032017
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF779180034E;
	Fri, 20 Mar 2026 18:40:16 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.202])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 48FE01953944;
	Fri, 20 Mar 2026 18:40:14 +0000 (UTC)
From: Audra Mitchell <audra@redhat.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	usama.anjum@collabora.com,
	colin.i.king@gmail.com,
	avagin@google.com,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V2] selftests/mm: Fix soft-dirty kselftest supported check
Date: Fri, 20 Mar 2026 14:39:14 -0400
Message-ID: <20260320184010.759461-1-audra@redhat.com>
In-Reply-To: <f7fef55d-4334-4d1d-b6c6-b409fea7e2a1@kernel.org>
References: <f7fef55d-4334-4d1d-b6c6-b409fea7e2a1@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: J7X3Eq54nEZLpalyQr02nQ9i6e7pzErEndmpRXJTGvo_1774032017
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: B153E140007
X-Stat-Signature: yf4pghr63pb1bnxjapk836p9ef9jcg8r
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774032028-358905
X-HE-Meta: U2FsdGVkX1+OqiabuUqLWE35A5lBHLYDR80IYTo9LmiQ7ybb/47RAiwxVMm5I3YjfUggxsI78dJd7iCmENVrsbRQCOmK0X9CfNWhiHuYg6d/v5ZQTHlTSGlw7dfFgoTlbFnV+jf/hG2DtZ1+FNQIl4kRq17RBK8gvdc+QFKwXngVHFdc25zJjMQrgKQHZiPPAc7DKwxdzn6tlXh0ESQx4CcqUaJwMw13nMGiILsJ2HVJ1aMKT7XIx0v1OQ1Q+FASR9bUbXBRe/MtviU9KvMQszM+IIVKKwZ4E6U0M/6lZnuzK20n9O9c7GC2nrE1HzfVXbxHE6pkzMgVxM5OwqAiKLYKyQxPGB+VHUZrg5IyR7FdWq7tC1Sx5s0gkHbvwjLIvlNedEAbUXXkOBXwlWJIC8LpUr5RB8kRSIvHib2Zx4wyLfVyvqf2LJR0l37ZDXiCLJwXx+mbBCyz226S06UnImGs8QHADRmaJQa0pETbEo/P4iUpITPD0Ge6KrMmn1UNUb5ZlnlSXih+hxIQVf4XiaOY2vmPNQO2L/ul7HJWJdqENGnCfLfrHzPrb8h/s2RMpg2Yn4iU0AhghLeZLtKdQp4GMQSyGOSZpNYBtItFkAEsnoW60HpQhGOkpv2IPWnFmlp/k4vXAbVTQLJWJc2k4nGNjM0mVo2z0oOGL2svwu2St07ApoR2PQbfAEKIs/nLI5iG1CEwqI6P3KlwEtU46fAFWDS2X4M14il4wft2OyI7tq0JhkT2IXhQfamZ9iJlKf0krfCBZ8KCxck8Fatv8WwrgjKxcnINkN7S1Y0pQB1yS7vP73JMTorxqcyaWfqVJButx75Ha1i8bJG4kJlquqUXDPwcUQFMH/nryEbKxzmaRhMHbeTzv86lVeWFs4mAnWAZMBl47FaKJhu3a3SDxzqqSl5QubpA52heBKG5GBQxa64FeHgAGhk7yZ1CmOVPaYh1LPTmit8s+uIEk7V
 vdl9FfHH
 pa1Jp19qoRmkNamkTn4H6BV6prLiwYnuz/daY1eWsVK2qYCNEHA7Jq/WSxwST962MgAKZhJPzp7yCo6VQQDCEi44NheJ39DorNTm510T15hlh0S9BuHti/Qsl/HRI9ABp0tgsRme3lU5DnMpupXokuGkIuCrFJm2FvQjJEIffXHu+JqJO/lpUc99icvslyfJwUiHyNQCYBlvuwxTyfrjzqAyM8F/9WC8e1861147LX5BxLNE9GBCWjdWmZ6Ks36C4ihh9gouxg8doGoPTyST7+Z3yo+NbiTCTOLqWYVwDk/FSAi+srNvobnNsLQ/lRuF4oS6pLaHXKFcdu4vUoqS9vR/7rp5p8gdl/G4uTJo2EncUQ25GrSOEz2q9IIZMLsvg5+dl1LJx+U8fVx4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sending V2:

Changes are:
1. Cleared up commit message
2. Adjusted the patch to reflect David's recommendations


