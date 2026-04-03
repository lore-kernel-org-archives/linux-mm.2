Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F21F6E7E36B
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 10:42:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65B506B0089; Fri,  3 Apr 2026 06:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E4E16B008A; Fri,  3 Apr 2026 06:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FBB46B008C; Fri,  3 Apr 2026 06:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 40AA96B0089
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 06:42:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E5EDD1A03C7
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:42:55 +0000 (UTC)
X-FDA: 84616906710.18.90A43FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 50188A0002
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:42:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I5tu38M3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775212974; a=rsa-sha256;
	cv=none;
	b=Wmp+UHzof9YG/p3sGuEzGngxrPXG9AW/Ygn7m/vGnQ8poXGSs8LwyQbCAroKPoog6POAV/
	HzWww/MXGaKTXlV/v6hlextNWZQqET6gtGnThsX/aCYcopX3FNo1SjaayQzeGchlzvNX8n
	nTniOzmxjzvbw84cSbmg2Qxw0n5EUG8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I5tu38M3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775212974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KSJMt4Vv67OiQnUoBlmsKG03y/UPJXzXaedLUuRi0lI=;
	b=3HM7SZxGzo5oPSG+/Y1RvUhbyXklUgdYALttqIXiOtRHMpxIJNe+sX8uljo2wXkllzKliO
	BdZlFq56CVZCOz121YDtYJyif6fBGv1dpX9CUW78EFyUTWNwi8XMw4kr4xDJ0Llzbu3h4Q
	rgPi1bNlDKH5WO1ZkztCNVCyP1PWhL4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 96FC560121;
	Fri,  3 Apr 2026 10:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A0AC4CEF7;
	Fri,  3 Apr 2026 10:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775212973;
	bh=0Pl0tHJSa+A8FXUPv/ufuLndsXrmGd/m2WDATXYEx24=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=I5tu38M3oFHgkgWPDyV5WIKLJABhtseeHrYFB0jULisjiuksVT+0dX9n1/dxNY168
	 SPErUpYGMQVZ7ZrV+yYTdDiYTTz3K8q4Ti0q9EJkTxx8efyZA25jPJCi1U7CTTJoog
	 nbNGJHgigqDP25YGmUsvkJq40M/YMPlBtNFpmGcipHhDcEMRBtFCnIl7NHQKSp3p8d
	 4Y0e2vmJlQSkZlryK+boJQQ+ww6m6fJxSFIICvPrq9cI0bu9F9QrcAwJYcHzyHV/cQ
	 1lbVb8CF9jlEfLjxOffJzkbbKCmJ0XRSNgAdAr/g6xpiC7mxwbTkwSr/5QTQSmQmlS
	 88Xk1livNIz5w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org,  akpm@linux-foundation.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,  pratyush@kernel.org,
  skhawaja@google.com
Subject: Re: [PATCH v3 10/10] liveupdate: Defer file handler module
 refcounting to active sessions
In-Reply-To: <20260327033335.696621-11-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 27 Mar 2026 03:33:34 +0000")
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
	<20260327033335.696621-11-pasha.tatashin@soleen.com>
Date: Fri, 03 Apr 2026 10:42:49 +0000
Message-ID: <2vxz5x68e34m.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 50188A0002
X-Stat-Signature: 36d6xob788qhrmeew6h1pg88g9gepe6z
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775212974-452792
X-HE-Meta: U2FsdGVkX1/hRNfYx+GOtoo0/+DAxuzXMWrJ34K8qXhjiz2iF9kkLjCjPjaUpfJvNeMUY8//4xz42fE0Y0vLJZhAncFxEgPCb73f7w0ckA+vGtgaQcsnmZ6PkeWlh+3Phsh5cJ7nCsCr3zY83Q/daezR9R3lQB1mwfvmxEZR+OBpO880UoFnqPIUjMqFhT25zZCuWwM//BbhPXAEM5izPxlSo5Qg7zfLebdDvZXWmLkV7uwluA+u5/zwPpsu5yRGsqVY/1PpHviCJrPgAid/E/i1SMzlx5xddaFGfXMYs0OJvltw6fcCn25vYxB71ck8dPxsTFPmHNXh+tckME52C/rdsXtpWZU9x+A6/7I8mMuM3i+S2C+Pg65Qsux2o6pqzKJN0uq7pRedKOGvezr9MqaAb5RN1t0tk4b0ByvSRwT8HCpfVUDicddp6KuDRgab0ob9Uzh+kTbU8aXenLKU3atvfjojUVgp13BXhvWX/yOnzzOEJza7Mlu5V56sH5Q11t+7pN2kppDwL+9eDK4rHjtDZA7gptoR0aqtYTiaMRbwF0bLSCx5q7B30sXMC0l0m6dCjW1f+q6BCzIUufzCBeHlSwhbSK59Q9n5lFzdCz2elH86FKJ8wg0rlbqwu3hVHMKkMKQPcHK6Wrxn/JRElkRH9oB0vFbkQNKREVoHGAIjvDA5hebe+aIGXXA3yWHZuaUP/hh9ge02NqtsBe187yymHU7PLpEbjoMVg12/zZViJ5wWPB1oGsCSP/9hRFgZejMUHSvBf2HA+ML7/Rh4nZjrDylRJ6KVUxJ2/UmseX1ry0B1PAs0BEBanWJVWSvDcbjrfMW6NVIWi8Q3ayQf0yPCB9g4uCb5lLy5f8uL7B3OnIgYMhbgvVIjUf38luj+UH9ORcESvj7PoPRpdJ4dor6CeiMQD7NImiCHnCniRIbPyd/dsCQNOSQhZ4IDS+LQKXqB57HiUdnIfUvywSt
 CsRfq6lg
 5hkVFhvCWqYB8MasokUVTarVHnffzvWfgwqsGyMk/FXb+iER+p/GP/eKB0R4odI5OEAfWx+cLfuMZjCA9YLSvLNoVePFUzw9Ja67wwzYiQ4hTlT1uysLjgeD3SoKK4yUK9m/EoKgSZaU3hX0jTlp4f8EGIFF9IS8KpcB7oA7knd4W3PMqqcI73r22FeDp9IshSB4kGk6msbOLNh16d/gwXhsTclAc+JZ3hqb0lFoF961n6rgnUPgySnIodg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27 2026, Pasha Tatashin wrote:

> Stop pinning modules indefinitely upon file handler registration.
> Instead, dynamically increment the module reference count only when a
> live update session actively uses the file handler (e.g., during
> preservation or deserialization), and release it when the session ends.
>
> This allows modules providing live update handlers to be gracefully
> unloaded when no live update is in progress.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

