Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00CC6C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 943F96B0138; Thu, 24 Jul 2025 05:17:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91BDF6B013B; Thu, 24 Jul 2025 05:17:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8318F6B013D; Thu, 24 Jul 2025 05:17:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 700276B0138
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:17:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3AE51120D5
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:17:17 +0000 (UTC)
X-FDA: 83698604556.23.3A7E604
Received: from sender4-pp-o95.zoho.com (sender4-pp-o95.zoho.com [136.143.188.95])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0BEB2C0005
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:17:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=zohomail.com header.s=zm2022 header.b="W/4r17Ej";
	dmarc=pass (policy=reject) header.from=zohomail.com;
	spf=pass (imf22.hostedemail.com: domain of safinaskar@zohomail.com designates 136.143.188.95 as permitted sender) smtp.mailfrom=safinaskar@zohomail.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753348636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4U4AlYanf8+Mm94ORgEbcJcvUtT1nMxCJY2bUMWIp4=;
	b=xGsvlb/zWPn1XmetvepnC/lFdHBWoKIhqULA4lhvHnKe/5UJzo97zKIWJCMBHZmN4F2+TR
	jGpzy5MQMtCGk1grqQHzIFvx0avbMkieEpbN79LctPeQnd0ps1MZORv430DoDL2HIGNvzD
	PuBLlVVQsSeRqLMVvziL9mqHHwfM7Kk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753348636; a=rsa-sha256;
	cv=pass;
	b=RJklcgydlLlIxR0woZURplQCNUaqepZXCMGbf0pNzNBsKzkKQG0mMBFwMwjkCoiXDLw7iz
	miqrN+HMdBHXDl8wIYyAiiy8kxh7uDDWC/BzrV7uU9OFO2nGQpooenfBBgjNge3+fVLDiM
	JwKxiJ/idRtQO950WQlrE1fC0+W2tu8=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=zohomail.com header.s=zm2022 header.b="W/4r17Ej";
	dmarc=pass (policy=reject) header.from=zohomail.com;
	spf=pass (imf22.hostedemail.com: domain of safinaskar@zohomail.com designates 136.143.188.95 as permitted sender) smtp.mailfrom=safinaskar@zohomail.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1753348578; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=c59k7OVc6GnzDLuO9f0SYKYKk/ERB/FbkKZ2QN6i8vKWQBq3ToRGQefdKm8z7I8BLAw9ExSwDRqcBQr8ZiuqcB/8Wjqjvk8cohPjySstEP1jRnULr4rGgOw3+znjq/SuUybg0BRGD6jyNFRjvKrKWgFKz8E1yvJcXansaapSwKA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1753348578; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=r4U4AlYanf8+Mm94ORgEbcJcvUtT1nMxCJY2bUMWIp4=; 
	b=eQ3bTifzakzOYvsdfM68sZVfZnObTipoKh7PiIcPRUNoIJe+V7E+jBZUMQ1/OjwayIbbsUcoBlO7Xm+oQYjD/6blKNCXh2zc6ytGF3LO5Z04HK/Q2S2xXB3ISduge4W8MDKqFyB1i3K9wVoX6jvGlkhrQTUSV67KzmOi3v0zNS4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zohomail.com;
	spf=pass  smtp.mailfrom=safinaskar@zohomail.com;
	dmarc=pass header.from=<safinaskar@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1753348578;
	s=zm2022; d=zohomail.com; i=safinaskar@zohomail.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Feedback-ID:Message-Id:Reply-To;
	bh=r4U4AlYanf8+Mm94ORgEbcJcvUtT1nMxCJY2bUMWIp4=;
	b=W/4r17EjUz7tKHd+Dty3fw+oquEqIMNatmXI2xbx9oovhQ9FcH+JYdYr6SXW3UZr
	44Hab9SNgc+Vyu5V/UwxKePkzp7AtuEF9Ns2E8cc7MW+54gCsY+ZLw3n05ChAnb9Grs
	ZJffpQ33guGJ6BEVSZFZ9UsqOeIkAcpJJZaFp2Nc=
Received: by mx.zohomail.com with SMTPS id 1753348576467207.84736617123485;
	Thu, 24 Jul 2025 02:16:16 -0700 (PDT)
From: Askar Safin <safinaskar@zohomail.com>
To: bhupesh@igalia.com
Cc: akpm@linux-foundation.org,
	alexei.starovoitov@gmail.com,
	andrii.nakryiko@gmail.com,
	arnaldo.melo@gmail.com,
	bpf@vger.kernel.org,
	brauner@kernel.org,
	bsegall@google.com,
	david@redhat.com,
	ebiederm@xmission.com,
	jack@suse.cz,
	juri.lelli@redhat.com,
	kees@kernel.org,
	keescook@chromium.org,
	kernel-dev@igalia.com,
	laoar.shao@gmail.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	lkp@intel.com,
	mathieu.desnoyers@efficios.com,
	mgorman@suse.de,
	mingo@redhat.com,
	mirq-linux@rere.qmqm.pl,
	oliver.sang@intel.com,
	peterz@infradead.org,
	pmladek@suse.com,
	rostedt@goodmis.org,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	vschneid@redhat.com,
	willy@infradead.org
Subject: Re: [PATCH v5 3/3] treewide: Switch from tsk->comm to tsk->comm_str which is 64 bytes long
Date: Thu, 24 Jul 2025 12:16:04 +0300
Message-ID: <20250724091604.2336532-1-safinaskar@zohomail.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250716123916.511889-4-bhupesh@igalia.com>
References: <20250716123916.511889-4-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-ID: rr080112277386df9982d4a0a50fd484250000d6cf96b2b2dd89700b60bbfae778d9f00cbe3c5cd847bf7583:zu08011227d3545089dbbe7029f132e8e000006a667f2294f193b7a928dd1a40d92bdd2c006e7a20faa6ebe9:rf0801122cad691eaec5235a908425c52200009ab00d1523b423f07b85d4c3bb9302abf9c739cc073320d82c0c0bbc6e4a:ZohoMail
X-ZohoMailClient: External
X-Stat-Signature: jcryoj8yspw87ypbd4mwbi99pfzk7aba
X-Rspamd-Queue-Id: 0BEB2C0005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753348635-119549
X-HE-Meta: U2FsdGVkX18uBAk5Z1kvU9Ib9QsP2z+lAD1VYJ/eHJQuIGhW/zg6Qrltk5FWo+kNXb5n2fRi+GHd2ezVEpyE5enWIzJGLl+M+V5+seh3b+/0Rzp66RfxLAU0h69qKl2mAffj6DrKaeAoMe/k3dKP3yLNs4947X1hbAd78v5whfuxtNHml4i9MUQuZ1FlOY4rsjLxClJsPLcrGAoh/uCj4++CQZkGg7z8k45eeI8PRQn0UPOWI1GlKfeKgAKzS4lsd8aEEVoVx8rMeJRlVODRxRtSbGwmO7RR+EnWexoY6WaOUwalq6vx+l8S6SjI+6W43pwrnT+nYoX7DoPO2IB2NFpTwc//EaZS6XjsQGy1dVvVxgL2JsIdE8NG2hwWaMIBrDJiFJHsDONJyqkiiNY+CoYwC70qlNjGgAJFWVeEIvOlR01P2A5DIrBWqMWuc1mHxpvd0eKLN7f/Kg3kqrjhgcZKab+yAFiEmh+PHuTsQmWCgZHOofaxtHgbgrsLHRJvMW2ziOmymWOx9BW/rRzq8KKIxBe+/W+R7aIm9QdYFdVaOPt7pU8Vvsv2nbZX7BWZC6ZOenfBZltIL6dvwbLFTs+YhF+MdOUA26rekFuXknFfPsYqxQFLGLGYHTMu3hFRvai+zZx1FRrIf9Wbt2sllU8cLCOjG/YlhI3bmy9XgFcOezMAx13Z8P8RtprGEoRv5GjeW1RDIwokK1HdUTdQgArcIhoCmysxnmoem25YqNcs/KAFY96/JeXLQcGzfmeFk3c3HMv59FM1U2/cg7q81gFkehWXCYnuXzP1xcGT8zoC2d29AsS0hDMxKTM1bKL3T2hwh3KFLYH29xwtNKJjZ7H0wNwjPvNBDcWUNHkahTH+3mEsJuXA1M86jLIy3H7G9TgIM3Gh9e5jT3XA+HtV72TCwOjZAPbQbC8Nw61UXWsTRIZ+cIHfZGPDzeKQN7WPYNEv10fNq+obYS7xDf1
 aNz7OgFz
 m6jftIhVXSTBrueOkv+1NUDGUWdWWRSwnZDVctU9k8UPr/OdJJz3dN4DahVJKPyu4gHrtVr9HFMyjVzalpqR8fK0KCUrHT4vjlIqtbkCFKFwL2Qb2ezJNMx8c0A6LVowgCaRaL1O4Rp/T0YchFu15eAK/0pcr7RbKhoZ84jltz9Zqr76cfMBCccfYtT/2nyOAFWAwuqkm3+jg+oivkPBwj/q+Xzq5AX6uy5ajp1Qaorz8QkpR5+ukXHezURuWqT7nYbklfyjEIGEXkbdNkcbmOgxxA3Xyl9P4M1OyWdPyptQo1KuhFwCGJrZDUEVjb4MpGDvTQCIdOSnMzIOD78Xb1JO6EzqKZMkOzT3gslMNXzzOlsrim01/XhFAFmSD0XEneNLg4bXdsk3h7TVgUPtX+Xzi8D5m3iRmCIsM5St0kPXJqZ3CUaFUpN5df3ECgKKXp/+GOYuUoUA3vR4Ukj9vZ4+0UxnYF/+YBpPhNFh4eoYoltQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> where TASK_COMM_EXT_LEN is 64-bytes.

Why 64? As well as I understand, comm is initialized from executable file name by default. And it is usually limited by 256 (or 255?) bytes. So, please, make limit 256 bytes.

--
Askar Safin

