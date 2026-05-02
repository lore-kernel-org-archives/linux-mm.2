Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3972CCCFA13
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 10:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DA236B0005; Sat,  2 May 2026 06:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58A136B008A; Sat,  2 May 2026 06:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A0436B008C; Sat,  2 May 2026 06:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3848A6B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 06:09:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD35EC214C
	for <linux-mm@kvack.org>; Sat,  2 May 2026 10:09:32 +0000 (UTC)
X-FDA: 84722057784.11.7ECFB42
Received: from embla.dev.snart.me (embla.dev.snart.me [54.252.183.203])
	by imf03.hostedemail.com (Postfix) with ESMTP id CEE9420003
	for <linux-mm@kvack.org>; Sat,  2 May 2026 10:09:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=reject) header.from=dev.snart.me;
	spf=pass (imf03.hostedemail.com: domain of dxdt@dev.snart.me designates 54.252.183.203 as permitted sender) smtp.mailfrom=dxdt@dev.snart.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777716571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tvhU2FPOdnW18DAKkmSWm6VtPzZONYyLIxcRcchGJ2Y=;
	b=YQNjpVgIOEVH0Z2u2JsO0KmKQvd8mm5nsf6SKwHC9Cjbc1oJmBsM8uBIxLxNt8zASbyJxu
	lUddGtfqiGS7nXlxHRrG/t8R2HjVQf2da57BUSESRWXCJFZ6qqsAFEJuo+VMJgeVYpfUAs
	mQ6DQ2oxwcAbA0Z7eN02bwPE/xyC7s0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=reject) header.from=dev.snart.me;
	spf=pass (imf03.hostedemail.com: domain of dxdt@dev.snart.me designates 54.252.183.203 as permitted sender) smtp.mailfrom=dxdt@dev.snart.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777716571; a=rsa-sha256;
	cv=none;
	b=JH+FfthZyH/TDADzaKoVXqiLBt7zo9nLMlhCzWSA1l2FulZB/mBz/WQ/7YRrP4cAcQHuSg
	BKgHxWEzigLjRmRkYt9Xwhwr3j2zkFrbWHhiwx4F0jBU2qpBGW2oCUJcAr893tWHnCpqn8
	6w3aG5DdaiKSnPL+6YI6dXFy5oro3bU=
Received: from embla.dev.snart.me (localhost [IPv6:::1])
	by embla.dev.snart.me (Postfix) with ESMTP id 114B21D490;
	Sat,  2 May 2026 10:09:26 +0000 (UTC)
Received: from [192.168.1.18] ([182.226.25.243])
	by embla.dev.snart.me with ESMTPSA
	id RUJcLVbN9WlfTQAA8KYfjw
	(envelope-from <dxdt@dev.snart.me>); Sat, 02 May 2026 10:09:26 +0000
Content-Type: multipart/mixed; boundary="------------OqT5KjLsi2Nj00j2V0JIyF7M"
Message-ID: <41ec0e37-ce27-4daf-972e-580ce0ed445b@dev.snart.me>
Date: Sat, 2 May 2026 19:09:25 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
To: syzbot <syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com>
References: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
From: David Timber <dxdt@dev.snart.me>
Content-Language: en-US, ko
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 syzkaller-bugs@googlegroups.com
Autocrypt: addr=dxdt@dev.snart.me; keydata=
 xjMEYmJg1hYJKwYBBAHaRw8BAQdAf5E+ri1XLtjqYbZdHOyc8oS+1/XJ5bSlbx5WHXmVBZzN
 IERhdmlkIFRpbWJlciA8ZHhkdEBkZXYuc25hcnQubWU+wpQEExYKADwWIQQn/Jn96EMUaIoF
 X+T/ldyyrZpWaAUCYmJg1gIbAwULCQgHAgMiAgEGFQoJCAsCBBYCAwECHgcCF4AACgkQ/5Xc
 sq2aVmjJZwD8COjPlUwccrlRvbNQ6f87DWchtYO0o8W2DNRM3RLps0EA/jEhIbRV6AsyC8jr
 30Ut3aJ3/mO/6G4sLj7OvkEEBH0MzjgEYmJg1hIKKwYBBAGXVQEFAQEHQFpgtIgaByv9lIEY
 EmpavMO0pYjtu7TMJynwdnGYkN9LAwEIB8J4BBgWCgAgFiEEJ/yZ/ehDFGiKBV/k/5Xcsq2a
 VmgFAmJiYNYCGwwACgkQ/5Xcsq2aVmhFCwEA0kM9VyYB4bLCM7+SuXUUH+5Ec99Nj4RXxFad
 Key9GuwA/2BZK6bNyrLSfEk2JDRoskqf7OIL0wa6JOD5SrBnMe8E
In-Reply-To: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
X-Stat-Signature: 1geh5cy6mwf8m9gqx7k4ukajfakh7kdn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CEE9420003
X-Rspam-User: 
X-HE-Tag: 1777716570-206411
X-HE-Meta: U2FsdGVkX19dm6GO47YrXYUUm1LM1gRfqVeGjJK3z/rt+4r2CTRt+tpHePnsJsgF9BBbR1mjndIk4gsCm4qo0hfvJPe7iiDyao0NYRUYjnKLKCWUpWQLV3EV8X7JPW2Jis6kqcT2v+/fJrR1SQ4y2CuQGI3/WxwQ8DLxPRSOLDzWCUvdEL3Ilg+RY7EpilHrEupZntCc3OplJ2n5Znq8G4dXmszsRyxxPgPoHe7nQIdXFrVva3AIGa/FNZRJ0voiMjTxw8LnvzDRcG6P/xJ+413atQZvD+rRAJy3UL4J4JvhnNPkMYsMF2LImLg207ddSrpwH9eK1NcA4yj0pnflV7LkMPjy5eCnwVb77hw11SafgOQ4AuT6BE8YvSCSzbV3hUQ6DhV1zUNw2zwmxiOa5rIfKXVkZFOV3ilXQH9RMe2rE6kXFt2qKGN1kqzL39xSy2JmEib8r0SKTJ1+NaQiuXypsZrtcawXrC9W2Uh8XX0UGuTqtGJhO3beOciCVXSh7un0cGSU8Rxar9cNpQcazTGCWG8XBM3KOmKTvx10gRzXhyU1Iuu3UYIXNtnTrH5oga0WhAiqrul2wsZfK6s1Q2mugtj0SOgbHoeXREU4KHqqj2MS1QqQnwTqrYyeyJCLZRkzDhZT5N7wcSF+hQN+LeUVUAMSGX8CLxjtAOaI5cqVYjE0ixaIPi3IO/4PsypCKFXtU/VF8cSjfWfqtnwiQdYdBrolPt0VLEW2jmfJbRO+1pUAIb3N2/3e90VHFDFJBG/NVE66ALYBRQEjB9jFvOLqShm3Qq7CRIRjpG4Wt+ofYq6HHXSoXlsMe8BsPcrPSJ7+rSjtrpB3HZ9+BIeEwxlqUFacDq0Rm4ebxqbT/hRX3dmpvXgkMoZDMaBjvD1flSg9B1wq2dGyYhkoWt2wjlWBep0R7p4G4o5wEbls7oaODdVfVArTstXGgoZKvoiEE3+nuxMCC8fmROuEY40
 sn/+2P6m
 hcVdNZwx6JUpJ60x72mH9OnOKqrLaG9tIfALRZMuE1x/c4DstDfruNpwowMoNjbKoCE8TeKk/sW3HY+iEzVLuNZAElxXM30LHcQbDlqtFdMaJfoR85staIaUssqOfQEmBiKWyyC/5LKpTIGZ06woocFYQrZNxxulRzr2JvAGlG6RAP6FMqVBI0wfGdcykg2Pq1Dr5qewlIQ9UhyTM+z+BEEANgqHkemLKSZ4Wq+ie2jnIoZQi804NZCD3zF58e06GBKCo1O1b4020rONZL17wseJ84+GFSf0+HNa49hYu8aL2M5dJbEuhB87/GxyQyZm0aGnBRHjtN4QNyGvnZ4wTB6Et9/IZvJTqJdQu74E14SOa+D3SpFh2SZg/DYwot6m0Ew+dKdXeKNw4yANkZmFB26XSlvUofFnmY+qA0mYL4yS6eulDQvw5Yc056X6ZtlWf3kkrjinfLwojuLsURLs9CdG4CipGhVHwE5s00o/7J9bcipiXpjHXpslb2P9hz1TfJG9SUgiLA8FxL8GsMIAZoQ+aKRBCIbii1gpVB8HYSNEv+QXDIQfzfLHbgff9lzbmeGZDPRYvS8PHbx1KDFGL3LtYr9GHhs0jFLBsL0jYQ4TFmiXer/zm8NXgWtg5QRsd+Ly/HvcdkvOMQUSZh4bYy/1TQTNkxQ/xNBHyE2ZIbA/bhQEEo/4vVJjbO0qihxZaswyjWlFKJWxkl1bnj5/UeB1FJZ0Pu7fDV7LWalxmX7R3Eb7m+oRpC2C0TWmsbKSv/i7S+m9ksshJ1nc/YvfV5AMy9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------OqT5KjLsi2Nj00j2V0JIyF7M
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

|#syz test|
--------------OqT5KjLsi2Nj00j2V0JIyF7M
Content-Type: text/x-patch; charset=UTF-8;
 name="syz-cae7809e9dc1459e4e63.patch"
Content-Disposition: attachment; filename="syz-cae7809e9dc1459e4e63.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2ZzL2V4ZmF0L3N1cGVyLmMgYi9mcy9leGZhdC9zdXBlci5jCmluZGV4
IDk1ZDg3ZTJkNzcxNy4uZGYxMGQ5YTc5YTI5IDEwMDY0NAotLS0gYS9mcy9leGZhdC9zdXBl
ci5jCisrKyBiL2ZzL2V4ZmF0L3N1cGVyLmMKQEAgLTY1Niw2ICs2NTYsNyBAQCBzdGF0aWMg
aW50IF9fZXhmYXRfZmlsbF9zdXBlcihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLAogZnJlZV9h
bGxvY19iaXRtYXA6CiAJZXhmYXRfZnJlZV9iaXRtYXAoc2JpKTsKIGZyZWVfYmg6CisJZXhm
YXRfZnJlZV91cGNhc2VfdGFibGUoc2JpKTsKIAlicmVsc2Uoc2JpLT5ib290X2JoKTsKIAly
ZXR1cm4gcmV0OwogfQpAQCAtNzUyLDYgKzc1Myw3IEBAIHN0YXRpYyBpbnQgZXhmYXRfZ2V0
X3RyZWUoc3RydWN0IGZzX2NvbnRleHQgKmZjKQogCiBzdGF0aWMgdm9pZCBleGZhdF9mcmVl
X3NiaShzdHJ1Y3QgZXhmYXRfc2JfaW5mbyAqc2JpKQogeworCWV4ZmF0X2ZyZWVfdXBjYXNl
X3RhYmxlKHNiaSk7CiAJZXhmYXRfZnJlZV9pb2NoYXJzZXQoc2JpKTsKIAlrZnJlZShzYmkp
OwogfQo=

--------------OqT5KjLsi2Nj00j2V0JIyF7M--

