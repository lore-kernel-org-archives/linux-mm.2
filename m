Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B51AFDEE4D
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 23:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48B966B0088; Thu, 23 Apr 2026 19:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43C386B008A; Thu, 23 Apr 2026 19:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 352146B008C; Thu, 23 Apr 2026 19:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 233386B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:48:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A32B81B84D2
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:48:58 +0000 (UTC)
X-FDA: 84691463556.20.0C019EE
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id E5C23C0008
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:48:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jsShxFlV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776988137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Lki0JX5m/qaGqm5DoBE8zLiop+9ooQpoPeZ7HcosWXk=;
	b=qY78Kv5EOWpOfZL+vuzfprn5KCJQAoaWYX1g6XKNIjQ8tg7sVFMNAo78WErv9bR55otQLh
	k3abj45dKp22d6wCY7kJmxBKk0TpSGw5RYxVLk6oHMVb5GwO6Pp7Sloyo4wlZlegMUJ+ca
	0Bu6/DRaxzEuP3RUME5FfBf/DQ1P6+I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jsShxFlV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776988137; a=rsa-sha256;
	cv=none;
	b=YVuGRVs+blq0XCPUlQTN0wru+5qllbZ2ctgujeBVDrcUfzVsOO1Ij71o+Y7gr0WTfkC9mH
	HZygVI1EcgbKlzxEx3adkG7HmzMVusWimjnsq5K6oPXVY5ZNNGFqO9W/1U4pjfoBj5KaZ5
	+IGF9JuxTQN0PbQuODjg3uXn9EKvEx8=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso67702365e9.3
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776988135; x=1777592935; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Lki0JX5m/qaGqm5DoBE8zLiop+9ooQpoPeZ7HcosWXk=;
        b=jsShxFlVfi73SrC64h9jlICdJnjs1cgNqogJ8aLqRK/aUT1WncK6Oh94lPJw7I55Ws
         PAQhgVmRCPMO72XjmFV/DYmNqYtlQu5lDivq9Y/Dn85bI4xlaNd5u6kCATQ0FNECCy7K
         lz8TR/oX8aVHE0qBwT1WlWOTc/vWxSnFKNXXEOKZr2OEh4jtfhMiMy8qOVo4eQzj+h2q
         HH1l/U4rX5chiPeGL9ZqUoPIwjDE3WzOERVxQvAEuPy+OMwcEzvLO4YRS2GpWBQcHfX7
         gQp1FJ1HFlJs6n0244pCucKyIQ8ezhR64NsZoh32xwu1maT9NmwMeBgAfi9oBwSmF0M5
         c2Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776988135; x=1777592935;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lki0JX5m/qaGqm5DoBE8zLiop+9ooQpoPeZ7HcosWXk=;
        b=ZBFbk5FXpcz1G3jdI0/BVArjHAWKFSbsNWGESOMXwhz+o2OQaNMje+Nrsxie4CVDiD
         3ApApmRj8fbamuNyuTzyk6UFd7y8+CGE5H9RzXNypWWdiNtxUvSE3mXgBy8v2NLDkg4k
         QafCZ0r6RA0vwkVeRRbdfVjo8bu8CUFrxqLTzS49+7CxobC1VKyjyxhTBxzrZxEzQ10C
         7LFN9WHoY8h1/W5pKBaTRM9SMQEC8Eaj8gze9QnOhXV49GsZPbLWb+xfaqMvh2ZdGaWp
         XJ4WpSsxKil1s3MZy+X+C4EJ9Z/4fdpDSHD/6xyQMj+RqnQqd+peBi2MRHqQWXcepoVb
         tZcQ==
X-Gm-Message-State: AOJu0Yy08nxerZmb6+TKQpyg8rtaHV4O3+xrx0JQFw/DMoX2k4BHeZkq
	4r4ChVTFN25r6pKb3RDGLjh4EaT+7a/Nje4aiNI3HQSvTX9P/CzEBkRy
X-Gm-Gg: AeBDievpHCdka3MkZbpLIlj7YvbBsDN16iSB0WCmEd6ZdFmHn7yJ7K0VnlJ2j0PWpNB
	6wM/gnJ8pS9BouWPPtiPN3gKXsIeh8gh8rC+BqYQSPug1EWtCw5Q9q8Pw86m64nVaYnPZSvA7Vd
	E2ChhGYTGbDWE2IbjJGXcTeQCO29SHMeOQ4gPgteisb7WmEXn8JKpSUWcRWJ1OOtxzkv1+6NR60
	5nqaTGxZvgzMIzRafIz32Hv/2WWj3XXCJVpX2wkE+K3NKWe1OGPpwlEd+nQD+buh4Kl1wfs5JP1
	rMUePX3UFp0vZx3HXQHTzFLJ9vgxBE9UQXlifjVnHseWWK0IpQ9/t7YNJzJyKeylfzAqy+Q5PC7
	FO60+0vXzjNCUDB1nUiub47BTAk0h93oLITTQgmFEmEmPOdjTkIuRwcHNJDYxJQYEPT9k2AcstO
	B1AMA1WMEWT9yNDBx5NjF98zOdRt+BrY14iNN92jU=
X-Received: by 2002:a05:600c:4e4c:b0:48a:58ae:9938 with SMTP id 5b1f17b1804b1-48a58ae9f69mr190862345e9.19.1776988135082;
        Thu, 23 Apr 2026 16:48:55 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:e8d7:434e:1f34:2cb6])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48a5c4b9e8dsm40476485e9.7.2026.04.23.16.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 16:48:53 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH v10 0/4] liveupdate: bug fix for session name and new ioctl to read it
Date: Fri, 24 Apr 2026 00:44:19 +0100
Message-ID: <20260423234753.3873095-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E5C23C0008
X-Stat-Signature: rotk597w7t1ccop1z77gb873g4so1ksm
X-Rspam-User: 
X-HE-Tag: 1776988136-685432
X-HE-Meta: U2FsdGVkX18yeEWKoNnkppCkclGm+aZklKMMEgRybgRbG0FRLj8u9z1UZd6aFOoTSrRp7MX9kqlq7glYciUh1xdhSRLPDZyMYPkAmT6/3CZu/ZpvUy8NlERsPjooN99vMwnrV33gEF4NhPj/uumFxgoDMosZgEmC6Qjz8jMNVODvJuAKYbiu2ukW/B8jfqUtybvKxHCUU1pH+DWGTplTZ1w+LCPKkhEpThMSmACiRMZD1IbzplPpuOa+UjkvQIfsrwtF5ZEfkFNyoPoKSmSz8akEstFHDyGdzUdAOfuZo15n5WMDGQ0OYu7HiNpXwJuFziO7g29PpzqJGeySit1xFjgk8LIq7jQFAgym97EetvMP0hUWqy7hMhGq6ASZy+9VDqD8lKk3QQJTw+9ZBMVh35G+T8kBwa0XPPPQy//HW9heUZPvwSgTg9aPVcHgvv4H//os7zVyg0wMvhmiemM1T9BErHmWSNx4k8ONdnBZj87+miIHFQkLmznXsKguI51knUufmhr3UwD0gfl5skHRfIKS2bcTjlLaImuYnbaBNWOP2TDBt3+d0IDbwHZdcHNvJX8oqScrJ7nyC5udwoVbo+Ciaqa0yAYPZw+y+yonvC3skQGd4CHu2cGn+/uqw2UOPzssMU/Fh8amx+BG7aeAeMHnXvp02gjGdlyEli8h5ZmVbtmZwq1QWVXN8pbFJj1ixG0nL61CZ1Lv6OJJ9VUuC6PPMmusfF7RraWbCpx3NcOE4kxh5MgTWsVFbyOcwHPg4tFfmoZ1eC6yGWb59I5lqhCUMjd3jWdoVM4qYWarDaViAnGCzL8+b+AtFQrEw0lbF6ZJhBzMce8NvuQx7VheYy9VIuFW39skROy9n+6OoVWCQP5T7LCQN7BAKTWiVzL9bjkQtMrCv7TzYXKWKngY4SIiUm511TsfaVLXjDYkOIq+zI9KL8QYYk3oSzI7aDoW4FpYPP+OqoDUyeJ4r9N
 VSOrqs9B
 yjTjCZaasjF07dmmuIwlAMUB6HfbIJQVbGDPo8dPdvnwQ7dm9oRKQgeFTf1d8fCdDjZESfrNrUjaQxrwPqry0nl1+QkXJHtxQDMoNyf6yKcmRF/5kjobmWyH1dEM+1Vw6WiU3I8kfRJ1jAxbsh/NNuFxHBDkx0YPYHcr2v2nHdnFObaJsizJC5G7UwCbVcEuLEJGKgr1ejQTs0aw55PBsLjoc9YUXYubvyrEe31yKBhr+tsr6NacF/Ix4vVOKhQEMSeqylwHSOFE+GdbJnW4FtqAGOC5X0QEEw4+8Tprb9wCH8auP0iZbTAUbIgNf+7Kpop7uiVB59Qi97OZM7poKzS80M3xF7b+BtQ2dAJJ7DWv4jkepPEyWRTspJ+zq83ZZmB1YS2N+rqv2lUIojrmGFBQONJnGvIgMb1/x9Ktr1UcKsvW0i+llBqVJ0qVW3ekJ2hX/jrkVxzbpaHPpxqFl0iEmaO166Hh3Ghd9jYWvd2mrh2p97JCXc9B9/jEZDzojfOTSCMZmUOHI65Q1t3Xhrf+wPfHoNwsoZSesp8dABM2ZTf6svcU5WELpbme804lhj41Zl55MlBlD7STy64EtTH2/apRkunHGCi6dOYgNixivBhY8zh25Eln7ITD6y6rz18PisCZicjYb5OpYOwOpEMfeagu3i/YFSxtmXC+xfHwTlvpOTzGyNfoWOge+KMHL8evtJUy+Qehwa/w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luca Boccassi <luca.boccassi@gmail.com>

A series of patches matured while implementing LUO support in userspace
in systemd.

- reject session names that are either empty strings or too long
- add new ioctl to retrieve session name from FD, so that userspace
  can query it without string parsing in procfs

Both changes come with a follow-up patch add test coverage via the
existing selftest.

v2: apply one fix from bot review about cleanup on error path:
    https://sashiko.dev/#/patchset/20260415184536.1155220-1-luca.boccassi%40gmail.com
    the other comments are invalid: luo is not a kmod, and the write hooks are not set up
v3: add test case to liveupdate selftest
v4: split test case in separate follow-up patch
v5: add r-b tag, merge series with LIVEUPDATE_SESSION_GET_NAME ioctl
    as they both change the same unit test source file, to avoid merge conflicts
    add '__u32 reserved' to the UAPI struct
v6: add more test cases as suggested
    more verbose commit message
    fix docstring
v7: apply suggestion from review bot to stub out setattr ops,
    like it was done in 22bdf3d6581a
v8: add new patches to reject session names that are empty or too long
v9: fixes following review comments on LUO_SESSION_MAGIC
v10: split out LUO_SESSION_MAGIC patch as it is undergoing more discussions,
     and the other two patches are independent aside from adding test cases
     to the same unit test source file

Luca Boccassi (4):
  liveupdate: reject LIVEUPDATE_IOCTL_CREATE_SESSION with invalid name
    length
  selftests/liveupdate: add test cases for
    LIVEUPDATE_IOCTL_CREATE_SESSION calls with invalid length
  liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
  selftests/liveupdate: add test cases for LIVEUPDATE_SESSION_GET_NAME

 include/uapi/linux/liveupdate.h               |  21 ++++
 kernel/liveupdate/luo_session.c               |  17 +++
 .../testing/selftests/liveupdate/liveupdate.c | 113 ++++++++++++++++++
 3 files changed, 151 insertions(+)

-- 
2.47.3


