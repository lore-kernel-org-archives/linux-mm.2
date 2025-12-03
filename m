Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD96FD116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 09:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CCFE6B0006; Wed,  3 Dec 2025 04:29:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A3E76B000C; Wed,  3 Dec 2025 04:29:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BA2B6B0095; Wed,  3 Dec 2025 04:29:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EE8666B0006
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:29:03 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 989FD58E2A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:29:03 +0000 (UTC)
X-FDA: 84177635766.23.69A8C5E
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id BE1824000A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:29:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VgKGWNhn;
	spf=pass (imf04.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764754141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OJl4vJuwyDpSRQ6QgxZUD7yK7xjBETvAgfX6HralMRU=;
	b=xXH70m87SGAidld2EW9r6ReImQTCumy4Y62E6K+w9Ua4tlmptJ4b+A5lfpDFb9zmNCwybG
	sT0dIr1F0xGBZI9ymJGq6KAxrgCAbOcYqbGai8hDoFgYWwC5fBXtRB76dJ4A1RF0C/EaJ+
	PA0JjGshoCJ2TTFw1t67FWhZkiBOzy4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764754141; a=rsa-sha256;
	cv=none;
	b=TfSg1F2GBVvakq75znp7SGVQ6N3hVbarAi1vYrhdBsB0rESLiUVv7KrcchoQTT0mbiM8/M
	9Dd/qDAw7EuGzhJrDbxgjx18FY/r2Fq1MEHZ9GejajkDTuvjQk1wmtakEiZvxc+ajPThMJ
	DTu9KqpKVroXfthhU/0P94PcCfFhGlM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VgKGWNhn;
	spf=pass (imf04.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-644fcafdce9so10803299a12.1
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 01:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764754140; x=1765358940; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OJl4vJuwyDpSRQ6QgxZUD7yK7xjBETvAgfX6HralMRU=;
        b=VgKGWNhnTlq4gvINUvy6cGxitqyai8L6yIvrKJWPGZW4ryILXSKuDEwaO34wKHdNh2
         g3Xl7uVCkHJZ/ZAE/Q6OC7BXDHWbb1OKXNq3LLpVdpv+cG6zc9TByDcoWr18PR96yN7s
         AcxYFo3RKOLCfFFuykwu4ZYYlzF5QpUXhAoIbMLPEvRlEwk9YiHnliEK27XVHmCiCSE7
         xJgqlVoKNWADT/cOBrasizjwguxDZ9kZBqwv8yK3kUVZ50ivUIXDTVK0S7G3cKGcS3aT
         V/iKskd5jVAtta/kOvYnVo5b0T7wyF6p8xCsEqRjEWKt4UaYrvl9UOnDlpBR0FaDxbwp
         jXlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764754140; x=1765358940;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OJl4vJuwyDpSRQ6QgxZUD7yK7xjBETvAgfX6HralMRU=;
        b=Ai3K7e70sbPjobaR8bDtzKvJbcfodTd9X7P0UCEsG/2/ULIerzKeVnggM8jZhkEZk3
         kSbwO1ZKh/wjUxxLquQ7OHrWlTUc2EwhtBrJeh8AQfclQ0UR8ZWw+kbpeml4o4i5eCbl
         t8h9PgOiVc9HN/JyGGogJQYdnTH4ejHQcr5AmCe2wtgJz/6FcirgRl5Su+RNqlv+FCTV
         U04QCHEPGfFdmWn57j6b6Ic07tXi9BB2PEdNs+rlw6VinYQnLsVijnjvt7gh9sow1/Eq
         FznI2iaEtKpqsy2GZ68jzAcqju3m33kUqsgBXkQcO9XK66fleh8u4csRo+LhnAdr86hx
         2BvA==
X-Forwarded-Encrypted: i=1; AJvYcCVyvKHGHtOCayB/52ubmlrSRFvLt3e3tn1svMcWrui81kawOl8xOOvs62qI3FLe1E3tMmDcp7Dqtw==@kvack.org
X-Gm-Message-State: AOJu0YxLPrsDEoq3nBh9/5GKoJ3qRAqArhmA9Pod7A1S3ov0kSiChD9k
	GdRmP0hthVSY3UH1145+DH67Erwr1wnEZJaro7Pi3lJRB1YePWLms7u4
X-Gm-Gg: ASbGncvj2Z03bNnBHtapIIDjdqFTymA0eu+CJ8evx3eaZGn68lEvVdDASfdrJWBM/tR
	HUVr7RYp8gMnBvyx10FlBVkAyg0XyPID+5u7abW2MW6OYsAbsTKra2bMwdlkuXCgiUB6CbltUkS
	Uiy0vSrieF/Y9dMcAPUz/4tG29MBLSpIgukBJYROCTw2TlnsZoBSKos1hRggXntPBr/p1S1nzz5
	ExflzdElzvW9XZRePISy7DimDgxg0tmPcJWVbiKIuzUYhuM3wcaq03RgILEVZ88AlwG1PVFI4aw
	j7oexfPdPWk+a6M8/y/1EnyY0XJugoZtuvDuKCgelmQoRA7pDk/cqCe/yW8j6Gn9K8DG8jc8KQb
	fIrHAhNFW3sLgCzjDdPiEWFA73xxspMghBCYtaFGMfIhXgdOGJdblgyEN649WR/JtfpBoS5IOXW
	eqjeH59ibSvx3xuaT+EMpoNkfQA/07iMgS1/GiKpWl+gWtd8rZAvlw7/Gcnac=
X-Google-Smtp-Source: AGHT+IF3+F+5LRAC6bKH9Pe1Zn5vprjhF1qCd3gmpOuk/TlFgRTWsY7rZUFwTPZeDr5lXTrvlKrTYA==
X-Received: by 2002:a05:6402:26c3:b0:640:cc76:ae35 with SMTP id 4fb4d7f45d1cf-6479c48bb3bmr1046073a12.21.1764754139666;
        Wed, 03 Dec 2025 01:28:59 -0800 (PST)
Received: from f.. (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64750a90d14sm17859981a12.10.2025.12.03.01.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 01:28:58 -0800 (PST)
From: Mateusz Guzik <mjguzik@gmail.com>
To: oleg@redhat.com
Cc: brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v2 0/2] further damage-control lack of clone scalability
Date: Wed,  3 Dec 2025 10:28:49 +0100
Message-ID: <20251203092851.287617-1-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BE1824000A
X-Stat-Signature: hqncar957cydrxeyqni3ufac58ohup9h
X-HE-Tag: 1764754141-705977
X-HE-Meta: U2FsdGVkX19C4cm2mdp81ldMK332aqoA5888//H3klYU1a+418eGWhhvFUR0OQ2yidnZ4QBTGoWtmfcasLq1ldZt2wOAOV4AnWa9l06ITIE7VFAIZNgKUeVYhC8ETIgWGdvqezorYgIdRjrGI1NKunOICgUj6kggU+8ui/drh1gP0Dvg9BT+hNYrt+9pEdfQpCMAkD7BUXAqf9VRzcxnowZ1ZKqSc9+n04aWUaX011xdxoDezzG48NzL2CP3nllAiUbccrTTgJCQxTHqpd0GvRCwIx4AKYuiwI3/wniy8HDL8pSfQI07Jm5KmOBRLUVOmWijdDrO4/Q7yLg7kd0pjs3HLNtwxALreFd4nAjepV1af4Gpv7nL3IRaqlsta3g72caoA5HdvLWeO1Vj52sA2N8laN2jkdNXzY9PY5fH7YfKH88Q+Ix3swYyiH6dZK8Td+3OESffKWtgZgq4CT74t8VvNCdUvpMSPix5Ov7R9LnnQmcgjOJVClGI7nxS5MgchzfjYxaXc1QcdAsj/Mzh9Tohw4S4M2VZpMdPY3BZ5CeYyC8zBpVEX7H2wrzPc3OuR0l1E2S+8QFd4/bcSGyT0Xn80kuM4VpW4nTFSwLk3MfBY2ickTBu6McB9NeoKOpInrKQZ6EC8HjvlHt7eLKAij8uWqgVXVScaGwF0DjHdFwHaUpAjzShhhjPOzw/R+9lL6VsD5EuediigQ2kx6NvZAyht12GOZ6IC29hgDjJ2HcXEoifeECXxuBLae0oxiI9Jhz1YYKACEh0QtDCTeMHPFguHMMwAL78Stx7FfdtTQM0fz0hwnBTnVYP7rrQag+K9Bzc6+qTLc9F7HhGtAZnyf0iOPhZyUDiTm7oMztYKgtMfIavrqduMGiy+K6AekIBqUajXM1lJ3/BPS4ghhlAeFrKn4YFxXAGd7/y/m9ZqzhnJeQ6lVTaNxOcUP8W4KMJvM98Anu/0pWWn3HygGM
 h4cEjUQC
 PES9+NJjhA6qd5hX3M8Mx0JeZvB/e5n+tu64w7twXYeDmzAnqSYb+FhInaco0N+0aO1+Z8LE554jjkCXL63jOQlKWnBD5P3Z8RfN+XsKtmWSFeVpbMSZBRJ8YgtyVHPfud5RgwIywBYVoP2rZ8YwmBP/EwFU1zWk7pZwpkhlsWtUKYyej0dVvsEqudirtl1PaXuP08CW9p8gWgrGzCAfzuNJBgNM3d46V8VfraDCQOLBS/+sgyLaLbKddmi8gdjKG28rvkcsEi9gIhW8ckNQw7z+Iwd86ahg4J7ZqOnNJayEDPHHJ1o5AsVM/P2OMvX71KrFYW/+LuYRvDM+izfbfklKqdEG+wUYqrnXUHFHwxo+ZVqIHW2Kv414Op2IkIPN48WSw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000002, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When spawning and killing threads in separate processes in parallel the
primary bottleneck on the stock kernel is pidmap_lock, largely because
of a back-to-back acquire in the common case.

Benchmark code at the end.

With this patchset alloc_pid() only takes the lock once and consequently
alleviates the problem. While scalability improves, the lock remains the
primary bottleneck by a large margin.

I believe idr is a poor choice for the task at hand to begin with, but
sorting out that out beyond the scope of this patchset. At the same time
any replacement would be best evaluated against a state where the
above relock problem is fixed.

Performance improvement varies between reboots. When benchmarking with
20 processes creating and killing threads in a loop, the unpatched
baseline hovers around 465k ops/s, while patched is anything between
~510k ops/s and ~560k depending on false-sharing (which I only minimally
sanitized). So this is at least 10% if you are unlucky.

bench from will-it-scale:

#include <assert.h>
#include <pthread.h>

char *testcase_description = "Thread creation and teardown";

static void *worker(void *arg)
{
        return (NULL);
}

void testcase(unsigned long long *iterations, unsigned long nr)
{
        pthread_t thread[1];
        int error;

        while (1) {
                for (int i = 0; i < 1; i++) {
                        error = pthread_create(&thread[i], NULL, worker, NULL);
                        assert(error == 0);
                }
                for (int i = 0; i < 1; i++) {
                        error = pthread_join(thread[i], NULL);
                        assert(error == 0);
                }
                (*iterations)++;
        }
}

v2:
- cosmetic fixes from Oleg
- drop idr_preload_many, relock pidmap + call idr_preload again instead
- write a commit message for the alloc pid patch

Mateusz Guzik (2):
  ns: pad refcount
  pid: only take pidmap_lock once on alloc

 include/linux/ns/ns_common_types.h |   4 +-
 kernel/pid.c                       | 131 +++++++++++++++++++----------
 2 files changed, 88 insertions(+), 47 deletions(-)

-- 
2.48.1


