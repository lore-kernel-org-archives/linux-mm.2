Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E735606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 14:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gd3cMPSg
Received: by kanga.kvack.org (Postfix)
	id 2BC646B05B1; Sun, 22 Nov 2026 09:00:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26D426B05B2; Sun, 22 Nov 2026 09:00:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 183F86B05B3; Sun, 22 Nov 2026 09:00:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBB466B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 09:00:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1BB758046A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:00:02 +0000 (UTC)
X-FDA: 85462913844.06.7AC8211
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4A34320003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:00:00 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gd3cMPSg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795356000;
	b=bdlAs5+hGKlQkM4KMTQRo7ZF2KYpF+CJbQA0or5cEIuiQzoGxzq3nW8+XyYQ9b0NUXXMvH
	Db6k0HkVZ5H0XL6RoHOI1VwgoIo150sy8oI0sTamJ/I5qJSA5nL5LyX4gvIxUgYPwmiRH9
	Mzu65KwqBVWgolfTteqWuMdfy8pZHvk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795356000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=990T3HNtPZH3bqJpbncLzkV3NXRnQ92AeqD5qJtei7w=;
	b=FLFUP4Z+C0qFYSq/vWXxBjlv+B3HBMWlm68mtdV6qo3oRge+n2jiF8n6jDZmoiueB2UrTJ
	atWKRCLnf1wL0hLxvPGO7ldlvjGx2JIsGkmWRgp1J7qC/lJ0AbfYIWhuRkWyGfcPIYGKi0
	cD0dUdUjL7oTi+m1eZExGzEi+Jpq42I=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gd3cMPSg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1b3beeaf6f9so2816402c88.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 06:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795355999; x=1795960799; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=990T3HNtPZH3bqJpbncLzkV3NXRnQ92AeqD5qJtei7w=;
        b=gd3cMPSghakMX0ZNhsGvHbdxeGha0xsteMm0MZWSFtAq/HIwNOofNIw2gGP6IXIqgM
         olMOF9sFJdMdesyq1PJF+AwCXtQPOAKX2aw74aAk66cQbseKJM0ysUBJWjiXSIM+a1Rp
         OEjdRU7s5AH7e623b+dh1eCb75HGl1oCKZN3QrHV0TLeJUca9cze8pkUX7UiGCWos7C5
         drF0vcZQEeNzoQNIv9+cyW/GPPOMABCq/hoGgrqW6o5tqm9Bfw3gYnAwvwtuZ56FcqkG
         zTfOZQjatz+6UsvxBbz4gWNPNg6XagvH/4iSIeMLwcQZYiv75l0nwV8GPZFh31906pg+
         QiTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795355999; x=1795960799;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=990T3HNtPZH3bqJpbncLzkV3NXRnQ92AeqD5qJtei7w=;
        b=InJ2nRIuwVsKFmwWIGAY9j+N221ieRIqyYgkKE9HTMfbnkbmNrdsEwCVFRL9dMZ/dk
         52s32I4wJw4Y3wlB+K7seMYjexZ8KM2wRosgLlBVK/ZjZYTtCrkJ/jAABpJhS0aTzYXX
         ToS9LPEdreYWxCYPmzNwwcAUtjafcPg0V3XhWtkBmURcLid8r1rFfOJNK6KkfrazMJoL
         KDQaaA02H1Rc/g0bM9Zyt+KWZlJW3oIlfVTw4MQ7/+kmFbLYyY8hc8sH3o2xxSqoashx
         qtp9yeUCXq1PMp4DUluufC3nIDu8wfdXkDBmDhMg5h6fpf/4OtFtaI2SJRlygTIt7BKw
         wmWg==
X-Forwarded-Encrypted: i=1; AL+hErGOoPOqP7OCXdJ3I1PAHbTpZW6IWbneHwKdzsenNK7UmqKwvoXIZTdNUmlrx46EzdPLNpsllnpoLA==@kvack.org
X-Gm-Message-State: APuU4Z92mzvwelDvqJ8AKj9S2N2mAr8MBVZE04eK4Y0objoVvBFlvl6/
	FU22q11M8gaDxsw9blwcmMUVE9oNFnJ/+s1UfWoMQnsFEeQ3cO26He/t
X-Gm-Gg: AZFdTZfk/0kusTDN27JLoaizGjoEdPPDzo5brIp270WRfuxdVZ0WzGL1rB9h4Gn/v+M
	5Z9j1GdBdLaZXR8+Y7pPSTGuOxWFnTZ+oVUCae09Ri3f+7r82lQ5pxbYgyP1yQyaNH6ZCnp1jOc
	4c5dkkiLi4oSvkEBv4Yhk0a9u5+sUcYl+gCvWfGf8ijMJHZFGXiF/Y8ExlNRkAUVCgAgLShyOUP
	sPCR+2LriP3AwSVqeZwRUhy5adnYVDWH70xDqm+8C4AEvI0ghQy55rjPTA1pE0gooOZKd8/UmEH
	zv4GTY8Bt3ORN9rj/swo53N7BtGlLoMfvF0D7MDddhW43BPSHc9Kl7KKIgQ6fOddoxQS0gSX8+J
	xfbWuZa5hXyXKAtkeGdVzvi29L660uR/5LR43xMfohQuD2jpXfvOybxiivSivWkxMIgcZYeQ/Cz
	ljp6AfwmwNEkYR7NRB7Rv/td6MohgBgoqPgAYEee9rK8tpp8I/bdmaQG1eerflbycX1q5QijE0p
	uHZWvrKKc7L+PEsl20IT8bDDfJ2zR+w/iDtCWOgVGTzbXyg/xZjcuAUQEktB3tnt/6XxAEW/ySh
	23ceP7WqzWrn6dKbZ2mx9QfLZZNtSCtmQ7KhaY0JwWoxHSBztOjZTGkNKobIl90N5eV3
X-Received: by 2002:a05:7022:b909:b0:1b4:f3af:355e with SMTP id a92af1059eb24-1b5568a660emr8203471c88.13.1795355998971;
        Sun, 22 Nov 2026 05:59:58 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567e2bd1sm20585980c88.3.2026.11.22.05.59.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 22 Nov 2026 05:59:58 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 04/27] mm/damon/sysfs: add admin/reports/ directory
Date: Sun, 22 Nov 2026 21:59:18 +0800
Message-ID: <20261122135941.78688-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-5-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-5-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4A34320003
X-Rspam-User:
X-Stat-Signature: jjjozffppj6w78bhj4f41rzdsmgow9qc
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795356000-533316
X-HE-Meta: U2FsdGVkX1/eV8vf1TTOz3ISZJ133+dcSqZIHXB413+wn91+GK/QSrqSLASComEGsbU3/Q5nSXZQTOTgB7TshaIoeMvK07MjzgXawUEjSFlWrtN7AiEcifjvrOPq4xBIEhSPZ+xKeFR4PSv8JFOWU3R/N5w3nXpkzCW6MHM9vnoHMQb43ZyBEZ/9wXxtx/pTSW6p1g975rwVGHBUsvJucpJv25+U975mul8gh08gGl65mg+m31edxRP7ccDx6JBf6qRd6LetEChkEaF5RTvO5SeKRYqpfn/a24/rIlm/xdxxBhmgrsIf/8IYFy1bxGeCYwRA/hiUveC0n1LJ2YiFMN5igswEYtQyCVPve9xOtBU32Dpwa/r2/Lip0BtYw2SVHnfpDDbgf1gGrJoRzt2lwqNplaW0x7mfUVEv77DtjDof3O/cIfrYc51PlqCy1FOhY+HStDehbz3UmkRWNcrBOgwq+WeedJffGJ412iITm8nchm6UggZrO1gJUiOMMck0VBru2ELvUwpfvAOpgsP/qsMCUXd37M0E+ki2+SzLTC7PQ/Fsm967QsMgp8h/u+76T3zjrkZduYx4F6nL1tYChhYgFCcrvfd4zQJ90W1IozvmgRjcWUxioFkrj/MmYo6VE4JCcVvyTBcvlicxkU3Rb0oFFNAvZzxzJAOr5vtavTkNMPZ+6/ryHEtoe0RXEoNizSzMBQwNCUqrHk/vlpkyAdhhNWQz+01EVnMyb+1dXHMJDqLnqxYm6l/uIgXM0Px/gt39QvO0A02/Eldi+/XAOAC7915u+7o8xU9Oa1686N+vsfsyVHOOyvtB9TMDeeqId4JJRxAInS1CR0Sys6kn02Zv84lKdNSHv0wsofaJwndT0a07DrUvJ20b/ztpzs8k8coegnVWdyR0+GanhM9v6K7fydPl6zmcSoJy0WezgZR9+ZMotLF/m3b+t8pdBtB8wcpYwLfjolELmCIloT1
 lR8OVy6y
 XF1aBz7ZeQdjvQx29HZPozRPd4z89j44z3BScUVManUI3d/20Fjy3ZWYNCArkEk0KBTigtQudZw420RqhenZmsREzzb6tLrsowiBqrRGaLVj2mZYaunLWcN2lRSE6MPi/xn6To1wrEwnnliDWzGsXqmBshaLzQCmwpyfwX7JEOxQLmPqVXluKRevdNn9UtQQFxDmnPZfznI189OtiGQ8Wj1zx2O0+Y/spP5oD19YXmAKraSRQFamP7iSLO0JVAIVNzBgnlwilL/FWd4MEUub8fSY8gy2yOl2ikvAud3WS0hQUQ1nNBjlP4i7pz91jPjDR77Pu0IeZNp3jXdff70lsfcZYXnFS1hKxZZKCSGuPYMZsao67Jg9hh2Sao1zpXwqUMRj/S+A69gpHJLUAGbMWjCTB9T7NhNILdZTozJQ0pfBD9H/daa5P1e8w05/+R/KV1iKyS4Qx1OWk9/jbSc5u9tIDV4dIsvdSwMaYu1TQLi08qIAebtZssLmdYEo9tb7sB5D0fJ6pghSeZ75K1MEVnQIRzeDe1/Zz8/FXQPDcF2z9Gl95UAs5I3ryN2cRCSHrI4eygbW4bTtSJ1AtwX/SPUDw0RQh7HR7M+SDpnDdnvZCJTf7QVUPBZsF5cEYWwlTRCISpqWyP2o5+VSy7EQwXV8h7y1W/C5aFC8p9FrOVig1kCWlUBCbX1JHHeYGgcsPrEpqiAt8uHpAxCsEM+O02yfP1EIH3GX9ZoP8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 12:59:48 -0800 SJ Park <sj@kernel.org> wrote:

> Add a new sysfs directory, reports/, as a place holder for sysfs files
> that will be used for controlling the data attribute report system.  Put
> the directory under the admin/ directory, next to kdamonds/ directory.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

