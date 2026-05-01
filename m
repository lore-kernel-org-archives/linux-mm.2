Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0703CD13DE
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 02:21:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D37236B0088; Thu, 30 Apr 2026 22:21:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE7C76B008A; Thu, 30 Apr 2026 22:21:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFE296B008C; Thu, 30 Apr 2026 22:21:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B08736B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 22:21:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0ECFB12037C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 02:21:19 +0000 (UTC)
X-FDA: 84717249078.07.9733936
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5221780002
	for <linux-mm@kvack.org>; Fri,  1 May 2026 02:21:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UZn6lwAU;
	spf=pass (imf02.hostedemail.com: domain of li.wang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777602077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3twploam4MV/bq5u/Ty0iH6HK100PxWqx9qv6h7XzQg=;
	b=oSHx5Q9PbXueb8j5Z15WfbO5vDQJt52nMOcFBsTFBVdztSHmP6lLjBF7j4pm2+0ng6TA4Y
	BguQUQSHM0V3gDRMFSGl2cHgg7l7VcXaD/xbfY9fyJRfcIhxbjYWO0l0tJuz5CP4Qi6upw
	FpodZy0Trfug0eDr0DnODu4OI0gL7Ko=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UZn6lwAU;
	spf=pass (imf02.hostedemail.com: domain of li.wang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777602077; a=rsa-sha256;
	cv=none;
	b=OwPC6GbNujg3J4kioOcZh3fm8rU+hvjpINen9S8pYLMsZdJsPLSUDtfH7Y6vfumzpPu0+l
	mT3C+/rQPGagklWHGpGD2kBd2LKlmfv72TgmksQo3l8dydyIuaxnGK0zedRDo+9BRz4gCk
	CS6YA7A/rKdF9n+h2AUvy4TGPwsM+pc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777602075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3twploam4MV/bq5u/Ty0iH6HK100PxWqx9qv6h7XzQg=;
	b=UZn6lwAUya5Xqtq40t+UrkKEXXFY9Z2IHb6Rwly1pbpj3+VOZ9/R474cwB5eDgVQvM3oFz
	tq4oR7/tjB2jcS5ypfFobRHj/IGmLL5MTnbWaRkWgjFUw47NQ/iWJQPXkmJDYH0Wbgi8lE
	soqpuUXGjwL2TyvDxA3aI1aUZnDg530=
From: Li Wang <li.wang@linux.dev>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	shuah@kernel.org
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] selftests/cgroup: Fix false positive failures in test_percpu_basic
Date: Fri,  1 May 2026 10:20:56 +0800
Message-ID: <20260501022058.18024-1-li.wang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: o66yeppu5cz6aea97ik51am1nguzqzkn
X-Rspamd-Queue-Id: 5221780002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777602077-645037
X-HE-Meta: U2FsdGVkX1/yCxwYkPRQL3rEzg4wtAe7iOM2TS766ScSMN4DnboAPdFy3idG7fqzrwihdxo4m6nriNR/6r0Xsxi6qegbR7B8bNYNQMTZXGfHpOOCKHP4/yB5zDbgCRt0/Jo3gA6UzT3dblu0xSfoS65jwp8Q9lqmhSDWiMSDlwa9nVI7ndwxUy5Sfh8DWLYYySHRAI3Edi2Aahjf7LqxzdZvc6YZ3TlD7i1LFUKpZ0NG3iq1rolmmHVBVvPZtuKE519mEpAaw2CnnNcu1nwf8DTHZ5hwIJfSkfDoXfdvXyGTMlGsXbmx8mnriT53XOZAKzRJXkkxwPFlZlQF0E88T9uXeq5K+qiSsHycX7HDNU4E7TCc5c9QyrzjzmOPDxAGSLHEGVu8PpaYc2OuDmFLTWehnlqsdSXmgT/8FnwqnIeFe6mZdZn7j8hRMt7dQGuZA+/uQOlGPCObyLAFYVUSbJDnaxl1h+UMx3FtaOQ4rXcSVyWiWrrWeEuaYe7Jaxv2ga00VDqfGs/zqdxQhsXTRtDbu40vgS77YpIc6F7Zm7H5WBGSeqmvVjUbAk4l/PIPDnlISHJjaBk2+6Qi4a3Bt20nHYbvnfgvi42wZYhPL8oI4h8IYT1SfBFsvWksbjtT7MXAVjbPTdpFtwaT05cm4YHylSd/KlF+Wfruuf0DtjSCXsefK/gbtihNEpDGrGdpTKn7PKmCyrlq83pl8Tug7Kdb45Hu0mqXPKYbyKsFt4NBLEf6+GY250rlU/SDc5mNY3129KU/Yfuo0dst8mXGgE5GDySvz/ek/AgnP+LrCv9/zUgHO0ZZv//dNu4T7DzrBa4qHru9v+chgOFwF2jjApRGmto1D8Ci72wg+mcHDXkJ2S/O7v9jNZgiLjWC698SPC27jiXWuDBRcBNn7GOzmxIiZ8y3sDRKe7AV3Mpipwa9egzHPGCa7tV545NMH9D9P6z+fsWj3VtyI5BTf1D
 eGZw+HDn
 eaYTGQa3RRQyMDHsTFIJt7wtFyPAGx0idjG53dwxJsT2YLt9MTBm5UBrw/geq7mYTMNfDpwlS5foQH9/dxE28irj7mT6oyNf/tkO2hQU+jsLWtqPeGBnUealE22U0JmtxwF5BgZlGw+nqnEplec+JMFlkgYS0TYnaEacXWbPj5k1oaGUk1zXw1zmlfTzHq35q/jfcXIIwFIee8/LRTSlVna+/cZ2NA0fsYyF2pIe93O3jbKz0QJeLptIezTrqFaCnYiVLNNsJH5594Dh+6XyYLvM8HA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series addresses two separate issues that cause false
positive failures in the test_percpu_basic test within the cgroup
kmem selftests.

The first issue stems from a hardcoded assumption about the system
page size, which breaks the test on architectures with larger page
sizes.

The second issue is an overly strict memory check that fails to
account for the slab metadata allocated during cgroup creation.

v2:
  * Replace my email with li.wang@linux.dev
  * Adding Waiman's Reviewed-by tag

Li Wang (2):
  selftests/cgroup: Fix hardcoded page size in test_percpu_basic
  selftests/cgroup: include slab in test_percpu_basic memory check

 tools/testing/selftests/cgroup/test_kmem.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

-- 
2.54.0


