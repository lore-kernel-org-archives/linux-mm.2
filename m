Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCCD2CA5FA3
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 19:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09AF86B0093; Mon, 28 Sep 2026 15:13:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04B2F6B0095; Mon, 28 Sep 2026 15:13:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4286B0096; Mon, 28 Sep 2026 15:13:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C83B66B0093
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:13:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6FD97A6558
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:13:20 +0000 (UTC)
X-FDA: 85264119360.01.7887D06
Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id C5E65A0005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:13:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JDzc+Zir;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790622798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pkU51f+1UpMIy8iBx8lVNiJZoAcmMG7LyZjfQO6BzzE=;
	b=pqz1CquYd9BSb3EQunN7lPZ34ZYwW/WLWfWgVZstCCcc6EjNu0iSgw1FaOaBnt4KoIMOny
	70eB4CIZvD28R3cMqNAI7CTi5mfyo6QbKs5nNY+anvoDUu6O9uHrva42APqtQSZV+auMkM
	8OZaEMpazyY0oKCPa+HMlRRzu0IlqOk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JDzc+Zir;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790622798;
	b=zHBZbrfeQmUZnX5I7nkClple+TFIU6oVfYVfl/D89kN9w3WOiDYMwFynLnb/oGKCpKRQV1
	bPnb803gsehQlFWN7pjaiON9n3RR9bWMy3KFEtySx9Z7xkiVI1bKwaQ3JOw20ARVXKsqaa
	JAV7vCLt5DIKVebwFxxkunrJwG7UKm4=
Received: by mail-pz2-f43.google.com with SMTP id 41be03b00d2f7-cc4aa0f1a94so1118638a12.2
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790622797; x=1791227597; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pkU51f+1UpMIy8iBx8lVNiJZoAcmMG7LyZjfQO6BzzE=;
        b=JDzc+ZirTLBAc668Rtjozgu/D/SOUrLh5BdLR7q/Clf5CfjOmzTDWb8hbmjAuR0iFp
         JyAuU4nHsIUnX7ejGkbaqhqgceIkdFjYLTfXpgcs0uHs06Z4Mr2VWkRb+I9FQNqs80J4
         2RNCZHUOJNzGHvJT4PbW4OrVqLP0tdLqIAh1cysPLxlr6eMwe7A3Lf2TLsqOH+EwlBYP
         OViYEGOG72XlSdUcipsUfpwC756dPeXS9Rmo8Sa8jhAWobj1Z+DSGhqdikNZKllgiotj
         /5N1lmESLfpIBEI7In/wlNihTxAr64E8cBJxBwKAgSR/C26k/y3X/C6QVir5PboqGIdY
         U+uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790622797; x=1791227597;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pkU51f+1UpMIy8iBx8lVNiJZoAcmMG7LyZjfQO6BzzE=;
        b=Pz4guUOwyUF3Bof6ysE5paQ4umqfJlCqcZM+s4DAG1NvEqEytsrHnEPPyW3ghaCHsr
         0drOstieX5rRuouNv5CcwbjK+1S31rBrY06SOwSQHpy+OZmOs5Pntwan0aePaJeJAvha
         YE8f9KVojQk4MqVR7HVatwJoaktJKz4spBYM/QG5GEodcxrBuCP47CQA94lSvKcE87Qy
         a7l8TtK5XwHFyiUfyEi9eutwaPtm0E/9D8w3/RMUL3YXNhHhNiNL01938uYW6WUIV4l2
         r3DUaVfhVxd7pu1KE7YV+isWyLrE5Z+XdBVi/ilG8gqHDil95UOkcv1OjEy7bPeD+fa5
         eWbw==
X-Forwarded-Encrypted: i=1; AKwUvBzkUCa/TAFE0ohZcKDVZKzNSAms+OdX66oxRn3LxvcitYRuhX1/bt0DI6q83RtKIZXcqWk3F2ggwQ==@kvack.org
X-Gm-Message-State: AFq9FYIi2hle+E4B10ekpoV6DxLEOXRWcGdWQmxV7UOppn7Jf8sHtnDn
	9M8wlmfhypXm2kxg3v4UN52c6HN0MWRxRJEk7jdPyC/mrGLRotcPMHlp
X-Gm-Gg: AYBFou24hx69pUsAX98ZW0eMG8HrnyN45zKgFTA0kgF0AFvPOkI4nHd+LG4Aump8sjh
	wAa4yJzLpx+xZgTnve+jmsE8KP0pptkvwN5M02G+M6nkU4ZoXYyCTjzRUv5ktXBP2Ci1mKmD759
	cDvi/cAn9rGrmFnZj3p5DxEPtqqD+1eXWerc2nqzwDsxjEY/NUPFTj92cFBvAeZQZm1pBHPmYrh
	zOJPJJQeOxTubABjvBKBqn569q4plzaBh2xO5PfBgcU+ssm1P6n9inM5EhwY7NOq+RoJJKP/rbs
	/zG0lbO0uGuBvRiTbFRMQyxo4QaQSdCm1yjTmQL3n73SrcMZ10GUqlsYpwET5w2yjRUfCeRnmQg
	QD5+wJQ3XmHzs8MUsC//TL3M6YxwhPVESChUJu6qcpTWuVdo+tIGMShYUXkpdlmFCgI6ljxTidO
	eNFXICcw98fgMjEipFCpTUyy0/WjzPy50H0N18LFlOJdeMUO4N1uJoAQYa5iDk3zVHORd27Eir
X-Received: by 2002:a17:90b:4d81:b0:3a0:b50d:50ea with SMTP id 98e67ed59e1d1-3a0b50d527emr9363041a91.28.1790622797440;
        Mon, 28 Sep 2026 12:13:17 -0700 (PDT)
Received: from celestia ([2402:1980:867:387a:70b:38f1:a1dd:9303])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc78794f224sm5177965a12.25.2026.09.28.12.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 12:13:16 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [RFC] mm/damon/damo: saving damon sysfs configuration
Date: Tue, 29 Sep 2026 03:13:06 +0800
Message-ID: <20260928191332.138511-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: c4gyea33g7yp3u17e1xxjz8p48rt59et
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C5E65A0005
X-HE-Tag: 1790622798-78637
X-HE-Meta: U2FsdGVkX1859s2JxkR6lk8HsuJeEadobjHQ10aLKbNTvc6cBKWSmigepPCTxq9IJOWT4foU1IsklkGyn7CBz/S/Zc/rB+dmuP8pMFLWBwXFPqxeKyeS2x73dx56qFQG2lhhOgMUmgToJ9cu1JoQRK90/JjIFoOxkCikVtHRiavK5ZLq8m/A8or5Vd7Mwlma+nnH8m9XGYi5f/tFdyci+UP33TrDD7wUsN8+CEMh1xSyVyeXpJ4N8n2zbztXY2nCd4OwtChNUTooO8g/GZaKfuW3VS1sLYHLH497dEJXxE0vUKOTR7gyrEla93EaZk+aJliBv8br1m72tDVOKiHlDH7quqC1dh4xfGdHO//VW5ROQpYZJDBm0Vxyu+xC+tMfMNXK8NCdQJU08qiSttYwsGrGAbRV5RujD/hjyRf8pzPXQ386DGxA6DD+Z4hyGEsiXNe9grODn8VbgkTDTunUxTBzUX3KK4T43elmlsYZ5SPe14pG8NkGbAzNkSPdD/bDEcyJfRRlVg3VNlWW7AqkRFkxHk+y9uVmhuE+3sOxA+zWYJpRBb+jSLo5xJKZ8fTqmSQBtglwkShh7kKsTv/nYiFA0cKp33vf2Eaqqd5IFJLzJIc3Z/mZo7o75DRWq2IzEhGpHV/jESyBPLdETj1NGOUFliagi5jwtCEkJHonmvDc70uufoiJ6efd7KW2A/jJ1x4b50sShp8KBgGdoOjdiyiuKGvLkEzjkFnPTx8RnJTPG62NmmCG0d5CBUWkAe1PkjgHHjL/ILCckUYe9UBJu0kYtLDmcTmPir6IMwWq4VHVIuUQIqxbGmFAveEXezDcty7QBVrEmQrmtu9Ur1r133nHO6BWwLXa3Cx6OUDBhTx9fLObFmO5svcjgDRBh1WRGW/7VxCmvpZY8z5GAHmi6NstVsw/rwivZErs8Phi5EvY1rC9L+IQWf41iyWBbXJ5mRe8dglTRGHmqyTV9w7
 7apmQCev
 W/JkAxfb1IJU1dlfbPG24mN36YzF52PHpZxFZP0mtiWll+vVLtOP9GnPbR91cWmi6gNlkVKE1/e5W2tU+4ASLZEkPUoCexsECHbFFpqGOOrg64ySuSdkpdRWWAVByDYLO3O19o3W8hPPw7Lgc3qgWOtf3a7FEEpXLCAt93yDrTbYvS7WNE0h2PKVzdNUfkgyLCpuJxim6V5ywLbsktFmMRiA0nhswDLKnaZMXYf9VSkK+X9jR+g4bwCs2r1bt7gvEjM93M/dDozEf0G/sdWyNogIOiyCmKIzZGldYLSmoLJInXZsiB9L9s9rAsSDyi7tXFue3ADeerFKx/KHbEbQRw1RKY+KvUt8vqEw90wYR8eNSVJVdt6m0dqZFv5Zco6/Z++tdVZmidGQFk7zV+9Q0M30vaZpoAADEIiEnk6Yde4N9NfnDT0JNw9eqHP63VRxk1ZJTH1OScP/t8T8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ and Community,

I've noticed that damo [1] doesn't seem to have a feature for saving
DAMON SYSFS configuration.  I tried 'damo args damon', but it doesn't
save the DAMOS schemes information.  'damo report damon --json' provides
more detailed information, but its output cannot be read by 'damo start
--kdamonds'.

I'd like to know if there is currently any way in damo to save the DAMON
SYSFS configuration that can be correctly read by 'damo start
--kdamonds'.  If not, would it be worth adding one?

[1] https://github.com/damonitor/damo

Best regards,
Rui Yan

