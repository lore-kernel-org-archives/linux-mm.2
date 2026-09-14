Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0822CC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 23:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D94166B0088; Mon, 14 Sep 2026 19:49:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D24326B008C; Mon, 14 Sep 2026 19:49:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEC116B0092; Mon, 14 Sep 2026 19:49:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 976B56B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:49:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 22F3C1C1EA3
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:49:34 +0000 (UTC)
X-FDA: 85214012268.25.06AB1C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7D78140003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:49:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aN2H49zm;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789429772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qseDGL6DGTE6ag7V6hK0YAZQ8hJbvq3vxBHJNlYWSsc=;
	b=XaM/brUV6qbYdpeo4Juxxbh/DAsEouyXVtXbS8oDMEzPogEkQbEOa1SQMsVvS+w38TklE9
	zh4vyeXxwyVHD165Zw+ayShAbmrQf7y/fK/Ka/gv2cSFPl3MzCSSySL/kiII4136SmNu1A
	GEApOy+ve230MEz0DT6BOPThl2Akz/Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789429772;
	b=vOe2V9oL4Y7/7cNgUpncbxGvEg2e1jB6+Lj2AAtpM0cOPVETaPq3oS0xL91I5w9qDLbDQu
	0EPFvWyf5H+PKsdMLnfX9rBlKUSCjIanCy6O0VnnxkqTFwewEa8AQbOV4b3Px6MVN1RmOx
	qIYO6fPN/2rVrgwm0pKhFIg17DYGONM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aN2H49zm;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AD6DD4353A;
	Mon, 14 Sep 2026 23:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE181F000FF;
	Mon, 14 Sep 2026 23:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789429771;
	bh=qseDGL6DGTE6ag7V6hK0YAZQ8hJbvq3vxBHJNlYWSsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aN2H49zmND70doM4Uq/R1eHAz406bNkb1X77f9LZfStN6GJzJnawesoh6UpZxM6Am
	 NdsR3vpEyR4tHZ0QSsQloS1sX2Hlxi0rDv0mr2WZGWWZLAD2xzWoIoQCbuZBfO6RbT
	 +qrHjF3mCOh7qPYMXe2KXr87SQab3GHa36yhfAKSnkLKp+sss80SbMKDIF8L9AZjCs
	 71OMjj9EnxnT3eXQBN4ug2ztHxwqdXcD7gyUjop26I0HcRdxPTAbgPG/Xp5ElvQMHQ
	 gJfQnAL/5jRgLQSUB9hQ74/RU/iMHF+5PftAmwAEAKl5AxhcCzQQ3qH4VvWVlfoWf2
	 xlz+LASXH8DXg==
From: SJ Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 8/8] mm/damon/core-kunit: test invalid damos filter commits
Date: Mon, 14 Sep 2026 16:49:23 -0700
Message-ID: <20260914234924.100335-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914155729.1518105-1-kunwu.chan@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ppqgm83rpgu6jxh3x77ow7uqjjyar3gq
X-Rspamd-Queue-Id: 7D78140003
X-HE-Tag: 1789429772-967218
X-HE-Meta: U2FsdGVkX1/4XY2ZBhl0b9V+K7C5Z9g/5zjGHTZJ2aCuhSO8UT0RQ0i1oWr09JR5TCx+QDs3B+d3G2EkClRMcxIjUDlR/ZFkNiMHVfpe/CG/pP6cXsh7YacayenudC97BPYyuleYzswEyh62jEJatdPZjRJbWWqvdmqkS9dP0ae8yL4R20ES4J23nbQDr+c6EpHxwt2hua+iOIgYRQEQloXxSeDMBesYOqAp+7HYcCOVlQQEUtgbr3BQK7FN753iznzMuxqdDhaZpb2tlwW3iFoaUH4b5AXrNxol1HpcBo2PfZ87OJrq6DTeLM/4HpcOts3ZJFA175BBF0caGnx4VZYA4ioXgYwJspfwG4Jw3ZHJpvxzUURM6g1OH0C0vEW2lpB3FbwoGk6cK72lXAMpMTOSJhzTBKrs/f0UdBcfwJskfyePPTY+RTw7zf/YIg3L7OeMi4hWO2HbeENlzJYgeyUoz2qaMXh5haTEidWb5wHIMbTkoWjcqpM9YKj+IObVVRWcHIaPfQ9NtOKl8ffoNlAflv+DxUMwJch09CncLV+OFxhfsUNXHxVYF6mKgn3BL9DPmylS77/sbIqDPluGPIC3s5b5qxJ28T81XUw6PrqCvV7fTWJpGwbKo0zEJTrzXZfLPfoVcvHk5mo9eLdk0I7dDWrlfTqFYHsSQ3MtV+mLEOmB8PFo6UifRUcAqgiWBEBaxcGEprlJKv/+dTqkAi4zlys0B6RGoepRPdH+FU9ZOuXglBjPZPe6QHeXps2arxo3Z2d/kCjB53TJvJqOCBXOu6Wsfu0Ipgzd+DnLNuVZ2lf6p3JPRho1c4td54ip9yWHqjl7qm4RhLbJ0xAmyV1c9Xl6Y4r5yWWwboHsj/KfLlJ6snobxsWHvaYb6CtAzZUKhBQo7Ij9RYfA43TBF/IIIGg2QFiQtEI4fS16vWnhaBIpPiPnT/4xRgoXGyB/iOpHz6QnFR1xNbuCZv/
 9Pc+KSLD
 irwIfSdlefaGThydZXl4XQQ84x21xRM3Wv00zw/WqHQ5E130Thuk/piGDfxhm40+cGbaf4skF42FfWigQMYuxsbU393oabu+Z4JPCORmYISjT/PQLx7lxqWL4A90qjK/vAVBwg62+udZS0ICfP7iPy+vGS2J1bw2Yp6jM+OAfb0i7lASPnRGPj/vobwTjEI/EYf1PB27vPRyk8px7JW0um9xWXneL1Xb3KU4fKQOIxOYWORl1f1iKqqDZHvMNnaJUuQnPTfBjSFuCERxE7vt693HjjvyEQBvFt5ONd3ZVfSrXl0QAe76oF42w9lBRO9lWyRNPmjcaorPdT8g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kunwu,

On Mon, 14 Sep 2026 23:57:27 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrote:

> On Sat, 12 Sep 2026 12:18:06 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > Add test cases for testing the validation of damos filter arguments in
> > commit time.
[...]
> Could we also test an invalid PROBE_HITS_WSUM range here?
> 
> Patch 4 adds the same max < min validation for
> DAMOS_FILTER_TYPE_PROBE_HITS_WSUM, but this test only covers
> ADDR and HUGEPAGE_SIZE.

I agree it is better to add a test.  But not necessarily together with this
series, in my humble opinion.  I am separately working on the test.


Thanks,
SJ

[...]

